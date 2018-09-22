package monitor

import (
	"fmt"
	"github.com/notyim/gaia/config"
	"github.com/notyim/gaia/monitor/core"
	"io/ioutil"
	"log"
	"net/http"
	"sync"
	"time"
)

// Agent constants.
const (
	AgentCapacity      = 600       // How many job agent can handle
	AgentBatchCheck    = 2         // How many check run in same go-routine
	AgentSignalStart   = "start"   // signal start string
	AgentSignalStop    = "stop"    // signal stop string
	AgentSignalCollect = "collect" // signal collect
	WorkerSignalStop   = "stop"
)

// Agent represent an agent that run checks
type Agent struct {
	Config     *config.Config
	InChan     chan *core.Service
	out        chan *core.HTTPMetric
	sigChan    chan string
	services   map[string]*core.Service
	cmdChan    map[string]chan string
	httpClient *http.Client
	lock       *sync.Mutex
}

// NewAgent create an agent with passing Output channel
func NewAgent(Out chan *core.HTTPMetric) (*Agent, error) {
	a := &Agent{
		lock: &sync.Mutex{},
	}
	a.InChan = make(chan *core.Service, AgentCapacity)
	a.out = Out
	//a.services = make([]*core.Service, AgentCapacity, AgentCapacity)
	a.services = make(map[string]*core.Service)
	a.cmdChan = make(map[string]chan string)
	a.sigChan = make(chan string)

	tr := &http.Transport{
		//TLSClientConfig:    &tls.Config{RootCAs: pool},
		DisableCompression: false,
		DisableKeepAlives:  false,
	}

	a.httpClient = &http.Client{
		//CheckRedirect: redirectPolicyFunc,
		Transport: tr,
		Timeout:   time.Duration(15) * time.Second,
	}
	return a, nil
}

// Start accepts data from input and sig channel for control flow
func (a *Agent) Start() {
	for {
		select {
		case s := <-a.InChan:
			go func() {
				log.Printf("Accept request to track service %v", s)
				a.lock.Lock()

				// existed service, we will destroy current worker
				if a.cmdChan[s.ID] != nil {
					a.cmdChan[s.ID] <- WorkerSignalStop
					a.cmdChan[s.ID] = nil
					a.services[s.ID] = nil
				}

				ch := make(chan string)
				a.services[s.ID] = s
				a.cmdChan[s.ID] = ch
				a.lock.Unlock()
				a.newWorker(s, ch)
			}()
		case s := <-a.sigChan:
			if s == AgentSignalStop {
				// destroy pool
				a.destroyWorkers()
				break
			}
		}
	}
}

// StopWorker stops worker that monitor service
func (a *Agent) StopWorker(serviceID string) (bool, error) {
	a.cmdChan[serviceID] <- WorkerSignalStop
	return true, nil
}

func (a *Agent) destroyWorkers() {
	for i, ch := range a.cmdChan {
		if ch != nil {
			log.Printf("Stop worker %i\n", i)
			ch <- WorkerSignalStop
		}
	}
}

func (a *Agent) newWorker(s *core.Service, ch chan string) error {
	timer := time.NewTicker(time.Duration(s.Interval) * time.Millisecond)
	//timer := time.NewTicker(time.Second * 10)

	// Get first check instantly :)
	go func() {
		log.Printf("Trigger first check for %s at %v", s.Address, time.Now())
		a.out <- a.fetch(s)
	}()

Loop:
	for {
		select {
		case t := <-timer.C:
			log.Printf("Fetch for %s at %s", s.Address, t)
			// @TODO error handle and logging with Raven maybe?
			a.out <- a.fetch(s)
			log.Printf("Fetch for %s done %s", s.Address, t)
		case action := <-ch:
			if action == "get" {

			} else {
				// @TODO more action here
				log.Println("Got signal %s Quit worker service %s", action, s.Address)
				break Loop
			}
		}
	}
	return nil
}

// Stop signals agent to stop
func (a *Agent) Stop() {
	a.sigChan <- AgentSignalStop
}

// fetch requests and timing the service
func (a *Agent) fetch(s *core.Service) *core.HTTPMetric {
	start := time.Now()
	rs := &core.HTTPMetric{}
	rs.Service = s

	req, err := http.NewRequest("GET", s.Address, nil)
	// Make sure we close http connection to avoid leaking file descriptor
	req.Close = true

	resp, err := a.httpClient.Do(req)
	if err != nil {
		log.Printf("Error %v for %s", err, s.Address)
		rs.Response.Error = err
		rs.Response.Status = -1
	} else {
		rs.Response.Error = err
		rs.Response.Status = resp.StatusCode
		rs.Response.Duration = time.Since(start)
		body, _ := ioutil.ReadAll(resp.Body)
		rs.Response.Body = fmt.Sprintf("%s", body)
		resp.Body.Close()
	}
	log.Printf("%s: %v in %d\n", s.Address, rs.Response.Status, rs.Response.Duration)
	return rs
}
