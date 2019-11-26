package gaia

import (
	"log"
	"time"
)

// Scheduler schedule job to run to agent
type Scheduler struct {
	ticker *time.Ticker
	done   chan bool
}

func NewScheduler() *Scheduler {
	s := Scheduler{
		ticker: time.NewTicker(5 * time.Second),
		done:   make(chan bool),
	}

	return &s
}

func (s *Scheduler) Run(push ScheduleChecks) {
	for {
		select {
		case <-s.done:
			log.Println("Shutdown scheduler")
			return
		case t := <-s.ticker.C:
			log.Println("Scheduler tick at", t)
			push.ScheduleChecks()
		}
	}
}
