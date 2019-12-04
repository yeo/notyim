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

type Agent struct {
	Name   string
	Checks *cmap.ConcurrentMap
	conn   *websocket.Conn
	// Gorilla websocket doesn't support concurently write, therefore this mutex
	mu          sync.Mutex
	config      *Config
	ScannerPool *scanner.Pool
}

func New() *Agent {
	hostname, _ := os.Hostname()
	checks := cmap.New()
	a := Agent{
		Name:   fmt.Sprintf("%s#%d", hostname, os.Getpid()),
		Checks: &checks,
		config: LoadConfig(),
	}
	a.ScannerPool = scanner.NewPool(&a, a.config.WorkerPool)

	return &a
}

func (a *Agent) ID() string {
	return a.Name
}

func (a *Agent) Run() {
	gaia.SetupErrorLog()
	a.Connect()
	a.SyncState()
}

func (a *Agent) Connect() {
	u := url.URL{Scheme: "ws", Host: a.config.GaiaAddr, Path: "/ws/" + a.Name}
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

func (a *Agent) ProcessServerCommand(evt *gaia.GenericEvent) {
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
			return
		}
		check := val.(*dao.Check)
		log.Println("Start to check", check.URI)
		a.ScannerPool.Queue <- check
	default:
		log.Println("Receive an unknow message", evt)
	}
}

func (a *Agent) SyncState() {
	defer a.conn.Close()
	done := make(chan struct{})

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
			go a.ProcessServerCommand(&evt)
		}
	}()

	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt)

	ticker := time.NewTicker(60 * time.Second)
	defer ticker.Stop()

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
			a.ScannerPool.Close()

			select {
			case <-done:
			// 30 seconds to force close
			case <-time.After(3 * time.Second):
			}
			return
		}
	}
}
