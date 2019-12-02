package client

import (
	"encoding/json"
	"fmt"
	"log"
	"net/url"
	"os"
	"os/signal"
	"sync"
	"time"

	"github.com/gorilla/websocket"
	"github.com/orcaman/concurrent-map"

	"github.com/notyim/gaia"
	"github.com/notyim/gaia/dao"
	"github.com/notyim/gaia/scanner"
)

func New() *Agent {
	hostname, _ := os.Hostname()
	checks := cmap.New()
	a := Agent{
		Name:   fmt.Sprintf("%s#%d", hostname, os.Getpid()),
		Checks: &checks,
	}

	return &a
}

type Agent struct {
	Name   string
	Checks *cmap.ConcurrentMap
	conn   *websocket.Conn
	// Gorilla websocket doesn't support concurently write, therefore this mutex
	mu sync.Mutex
}

func (a *Agent) Run() {
	a.Connect()
	go a.StartCheckers()
	a.SyncState()
}

type Scanner interface {
	Perform()
	Stop()
}

type HTTPScanner struct {
	Queue chan string
	Done  chan bool
}

func (s *HTTPScanner) Peform() {
	select {
	case job := <-s.Queue:
		log.Println("Doing HTTP scane for", job)
	case <-s.Done:
		s.Stop()
	}
}
func (s *HTTPScanner) Stop() {
	log.Println("Stop Scanner")
}

func (a *Agent) StartCheckers() {
	scanner := HTTPScanner{
		Queue: make(chan string, 10000),
		Done:  make(chan bool),
	}

	go func() {
		for {
			scanner.Peform()
		}
	}()
}

func (a *Agent) Connect() {
	u := url.URL{Scheme: "ws", Host: "localhost:28300", Path: "/ws/" + a.Name}
	var err error
	a.conn, _, err = websocket.DefaultDialer.Dial(u.String(), nil)

	if err != nil {
		log.Fatal("dial:", err)
	}
}

func (a *Agent) PushToServer(payload []byte) error {
	a.mu.Lock()
	defer a.mu.Unlock()
	err := a.conn.WriteMessage(websocket.TextMessage, payload)
	if err != nil {
		// TODO: Impelement retry and re-connect
		log.Println("Write Error:", err)
	}

	return err
}

func (a *Agent) SyncState() {
	defer a.conn.Close()

	go func() {
		for {
			_, message, err := a.conn.ReadMessage()
			if err != nil {
				log.Println("Error when recieving message from server", err)
				// Retrying server connection
				return
			}
			log.Printf("Message from server %s", message)

			var evt gaia.GenericEvent
			if err = evt.UnmarshalJSON(message); err != nil {
				continue
			}

			switch evt.EventType {
			case gaia.EventTypeCheckInsert:
				a.Checks.Set(evt.EventCheckInsert.Check.ID.Hex(), evt.EventCheckInsert.Check)
			case gaia.EventTypeCheckReplace:
				a.Checks.Set(evt.EventCheckReplace.Check.ID.Hex(), evt.EventCheckReplace.Check)
			case gaia.EventTypeCheckDelete:
				a.Checks.Remove(evt.EventCheckDelete.ID.Hex())
			case gaia.EventTypeRunCheck:
				log.Println("Run check", evt.EventRunCheck)

				val, ok := a.Checks.Get(evt.EventRunCheck.ID)
				if !ok {
					log.Println("Server request check but it didn't exist on client state", evt.EventRunCheck)
					continue
				}
				check := val.(*dao.Check)
				log.Println("Start to check", check.URI)
				go scanner.Check(check)
			default:
				log.Println("Receive an unknow message", err)
			}
		}
	}()

	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt)

	ticker := time.NewTicker(60 * time.Second)
	defer ticker.Stop()

	done := make(chan struct{})

	pingCmd := gaia.NewEventPing()
	pingPayload, _ := json.Marshal(pingCmd)
	for {
		select {
		case <-done:
			return
		case t := <-ticker.C:
			log.Println("Ticker at", t)
			a.PushToServer(pingPayload)
		case <-interrupt:
			log.Println("interrupt")

			// Cleanly close the connection by sending a close message and then
			// waiting (with timeout) for the server to close the connection.
			err := a.conn.WriteMessage(websocket.CloseMessage, websocket.FormatCloseMessage(websocket.CloseNormalClosure, ""))
			if err != nil {
				log.Println("write close:", err)
				return
			}
			select {
			case <-done:
			case <-time.After(time.Second):
			}
			return
		}
	}
}
