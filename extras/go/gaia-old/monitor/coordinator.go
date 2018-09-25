package monitor

import (
	"bufio"
	"github.com/notyim/gaia/monitor/core"
	"log"
	"os"
)

// Coordinator accepts invoming data and forward to Agent channel for processing
type Coordinator struct {
	AgentChan chan *core.Service
}

// NewCoordinator create a coordinator with specified agent channel
func NewCoordinator(agentChan chan *core.Service) *Coordinator {
	c := &Coordinator{agentChan}
	return c
}

// Start accepts incoming data and forward to agent channel
func (c *Coordinator) Start() {
	// @TODO
	// Fetch data from source in a loop and notify agent channel about new data
	// or notify agent channel about removing of data

	c.AgentChan <- core.NewHTTPService("https://axcoto.com", "1", 20000)
	// c.AgentChan <- core.NewHTTPService("https://log.axcoto.com", "2", 2000)
	if s := os.Getenv("GAIA_BENCHMARK"); s != "" {
		c.bench()
	}
}

func (c *Coordinator) bench() {
	file, err := os.Open("./url")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		url := scanner.Text()
		c.AgentChan <- core.NewHTTPService(scanner.Text(), url, 10000)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
