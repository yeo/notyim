package client

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/notyim/gaia/types"
	"log"
	"net/http"
	//"net/url"
)

const (
	MaxFlusher = 100
)

type Flusher struct {
	Host   string
	ch     chan *types.HTTPCheckResponse
	quit   chan bool
	client *http.Client
}

func NewFlusher(to string) *Flusher {
	f := Flusher{
		Host:   to,
		ch:     make(chan *types.HTTPCheckResponse, MaxFlusher),
		quit:   make(chan bool),
		client: createRequestClient(),
	}

	f.Start()
	return &f
}

// register writter that listens on result channel and flush to gaia
func (f *Flusher) Start() {
	for i := 0; i < MaxFlusher; i++ {
		go func() {
			for {
				select {
				case checkResponse := <-f.ch:
					f.Flush(checkResponse)
				case <-f.quit:
					return
				}
			}
		}()
	}
}

// Write the result to gaia
// This actually queues the check into channel to be flush later
func (f *Flusher) Write(res *types.HTTPCheckResponse) {
	f.ch <- res
}

// post check result to gaia
func (f *Flusher) Flush(res *types.HTTPCheckResponse) bool {
	endpoint := fmt.Sprintf("%s/check_results/%s", f.Host, res.CheckID)
	log.Println("Flush check result", res.CheckID, "to", endpoint)

	body, err := json.Marshal(res)
	if err != nil {
		return false
	}

	req, err := http.NewRequest("POST", endpoint, bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	_, err = f.client.Do(req)

	if err != nil {
		log.Println("Fail to flush", res.CheckID, "err", err)
		return false
	}

	return true
}
