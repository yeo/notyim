package client

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"sync"
	"time"

	"github.com/gorilla/websocket"
	"github.com/orcaman/concurrent-map"

	"github.com/notyim/gaia"
	"github.com/notyim/gaia/dao"
	"github.com/notyim/gaia/scanner/httpscanner"
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

				go func(chk *dao.Check) {
					t0 := time.Now()
					defer func() {
						log.Printf("Check %s finish in %v", chk.URI, time.Now().Sub(t0))

					}()
					req, err := http.NewRequest("GET", chk.URI, nil)
					if err != nil {
						log.Println("Error creating http request for")
						return
					}

					req.Header.Set("User-Agent", "noty/2.0 (https://noty.im)")
					var result httpscanner.Result
					var cancel context.CancelFunc
					ctx := httpscanner.WithHTTPStat(req.Context(), &result)
					ctx, cancel = context.WithCancel(ctx)
					time.AfterFunc(30*time.Second, func() {
						cancel()
					})

					req = req.WithContext(ctx)

					httpClient := &http.Client{
						Timeout: 30 * time.Second,
						Transport: &http.Transport{
							Dial: (&net.Dialer{
								Timeout:   30 * time.Second,
								KeepAlive: 30 * time.Second,
							}).Dial,
							TLSHandshakeTimeout:   10 * time.Second,
							ResponseHeaderTimeout: 10 * time.Second,
							ExpectContinueTimeout: 1 * time.Second,
						},

						CheckRedirect: func(req *http.Request, via []*http.Request) error {
							// always refuse to formatllow redirects,
							return http.ErrUseLastResponse
						},
					}

					res, err := httpClient.Do(req)
					if res != nil {
						defer res.Body.Close()
					}
					if err != nil {
						log.Println("Error when perform http check request")
						return
					}
					body, err := ioutil.ReadAll(res.Body)
					if err != nil {
						fmt.Println(err)
						return
					}
					result.End(time.Now())

					metric := &httpscanner.CheckResponse{
						RunAt:         time.Now(),
						StatusCode:    res.StatusCode,
						Status:        res.Status,
						ContentLength: res.ContentLength,
						Header:        res.Header,
						Timing:        result.ToCheckTiming(),
						Body:          body,
					}

					log.Printf("Response metric %v\n", metric)
					log.Printf("Timing %v", result.Durations())

					runResult := gaia.EventCheckHTTPResult{
						EventType: gaia.EventTypeCheckHTTPResult,
						ID:        check.ID.Hex(),
						Result:    metric,
					}
					resultPayload, _ := json.Marshal(runResult)
					a.PushToServer(resultPayload)
				}(check)

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
