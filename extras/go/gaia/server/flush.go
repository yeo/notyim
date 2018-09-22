package server

import (
	//"fmt"
	"github.com/jrallison/go-workers"
	"github.com/notyim/gaia/models"
	//"github.com/notyim/gaia/types"
	//"log"
	//"net/http"
	//"net/url"
	//"time"
)

const (
	MaxFlusher = 2000
)

type Flusher struct {
	ch   chan *models.CheckResult
	quit chan bool
}

func NewFlusher() *Flusher {
	f := Flusher{
		ch:   make(chan *models.CheckResult, MaxFlusher),
		quit: make(chan bool),
	}

	f.Start()
	return &f
}

func (f *Flusher) Write(m *models.CheckResult) {
	f.ch <- m
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

// Flush result to InfluxDB, and queue job to check
func (f *Flusher) Flush(checkResult *models.CheckResult) bool {
	checkResult.Save()
	workers.Enqueue("check", "CheckToCreateIncidentWorker", []string{checkResult.CheckID, string(checkResult.ToJson())})
	return true
}
