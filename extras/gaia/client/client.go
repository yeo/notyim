package client

import (
	"encoding/json"
	"fmt"
	"log"
	"net/url"
	"os"
	"os/signal"
	"time"

	"github.com/gorilla/websocket"

	"github.com/notyim/gaia"
)

func InitClient() *Agent {
	a := New()

	return a
}

func New() *Agent {
	hostname, _ := os.Hostname()
	a := Agent{
		Name: fmt.Sprintf("%s#%d", hostname, os.Getpid()),
	}

	return &a
}

type Agent struct {
	Name string
}

func (a *Agent) Run() {
	go a.StartScheduler()
	a.SyncState()
}

// StartScheduler initialize all checkers
// Each checker usually run on 4 go-routine which regularly get job from server to process
func (a *Agent) StartScheduler() {

}

func (a *Agent) SyncState() {
	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt)

	u := url.URL{Scheme: "ws", Host: "localhost:28300", Path: "/ws/" + a.Name}

	c, _, err := websocket.DefaultDialer.Dial(u.String(), nil)

	if err != nil {
		log.Fatal("dial:", err)
	}
	defer c.Close()

	ticker := time.NewTicker(60 * time.Second)
	defer ticker.Stop()

	done := make(chan struct{})

	go func() {
		defer close(done)
		for {
			_, message, err := c.ReadMessage()
			if err != nil {
				log.Println("Error when recieving message from server", err)
				// Retrying server connection
				return
			}
			log.Printf("Message from server %s", message)
		}
	}()

	pingCmd := gaia.NewEventPing()
	pingPayload, _ := json.Marshal(pingCmd)
	for {
		select {
		case <-done:
			return
		case t := <-ticker.C:
			log.Println("Ticker at", t)
			err := c.WriteMessage(websocket.TextMessage, pingPayload)
			if err != nil {
				// TODO: Impelement retry and re-connect
				log.Println("Write Error:", err)
				return
			}
		case <-interrupt:
			log.Println("interrupt")

			// Cleanly close the connection by sending a close message and then
			// waiting (with timeout) for the server to close the connection.
			err := c.WriteMessage(websocket.CloseMessage, websocket.FormatCloseMessage(websocket.CloseNormalClosure, ""))
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
