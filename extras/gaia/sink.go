package gaia

import (
	"encoding/json"
	"log"

	// We can remove this when fully switch to go mod for this client
	_ "github.com/influxdata/influxdb1-client" // this is important because of the bug in go mod
	client "github.com/influxdata/influxdb1-client/v2"

	"github.com/notyim/gaia/sidekiq"
)

type Pipeable interface {
	ToMetric() map[string]interface{}
}

type SinkConfig struct {
	Addr string
	DB   string
}

type Sink struct {
	Pipe         chan Pipeable
	Done         chan bool
	config       *SinkConfig
	influxClient client.Client
	Queue        *sidekiq.Client
}

func NewSink(config *SinkConfig, sidekiqConfig *sidekiq.Config) *Sink {
	c, err := client.NewHTTPClient(client.HTTPConfig{
		Addr: config.Addr,
	})

	if err != nil {
		log.Fatal("Cannot create influxdb client", err)
	}

	return &Sink{
		// TODO: Make 1000 a condigurable value
		Pipe:         make(chan Pipeable, 1000),
		config:       config,
		influxClient: c,
		Queue:        sidekiq.NewClient(sidekiqConfig),
	}
}

func (s *Sink) Run() {
	for {
		select {
		case evt := <-s.Pipe:
			checkResult := evt.(*EventCheckHTTPResult)
			log.Printf("Start to process in Sync %s %v", checkResult.ID, checkResult.Result.Timing)

			payload, err := json.Marshal(checkResult.Result)
			if err != nil {
				log.Printf("Cannot encode json %v", err)
				continue
			}
			s.Queue.Enqueue("CheckToCreateIncidentWorker", []interface{}{checkResult.ID, string(payload)}, "check")

		case <-s.Done:
			break
		}
	}
}
