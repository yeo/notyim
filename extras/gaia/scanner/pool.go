package scanner

import (
	"log"

	"github.com/notyim/gaia/dao"
)

type Pool struct {
	Queue chan *dao.Check
	Done  []chan bool
	Agent MetricWriter
}

func NewPool(agent MetricWriter, total int) *Pool {
	pool := Pool{
		Queue: make(chan *dao.Check),
		Agent: agent,
	}

	pool.SpawnWorker(total)
	return &pool
}

func (p *Pool) SpawnWorker(total int) {
	p.Done = make([]chan bool, total)
	for i := 0; i < total; i++ {
		p.Done[i] = make(chan bool)

		go func(done chan bool) {
			for {
				select {
				case item := <-p.Queue:
					Check(item, p.Agent)
				case <-done:
					log.Println("Receive done signal. Exit")
					return
				}
			}
		}(p.Done[i])
	}
}

func (p *Pool) Close() {
	for _, v := range p.Done {
		v <- true
	}
}
