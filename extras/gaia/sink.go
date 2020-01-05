package gaia

import (
	"log"
	"time"

	// We can remove this when fully switch to go mod for this client
	_ "github.com/influxdata/influxdb1-client" // this is important because of the bug in go mod
	client "github.com/influxdata/influxdb1-client/v2"

	"github.com/notyim/gaia/errorlog"
	"github.com/notyim/gaia/sidekiq"
)

type CheckPipeable interface {
	QueuePayload() ([]byte, error)
	MetricPayload() (map[string]interface{}, error)
	CheckID() string
	CheckType() string
}

type SinkConfig struct {
	Addr string
	DB   string
}

type Sink struct {
	Pipe         chan CheckPipeable
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
		Pipe:         make(chan CheckPipeable, 1000),
		config:       config,
		influxClient: c,
		Queue:        sidekiq.NewClient(sidekiqConfig),
	}
}

func (s *Sink) Run() {
	for {
		select {
		case evt := <-s.Pipe:
			// Queue event into Redis
			if payload, err := evt.QueuePayload(); err == nil {
				s.Queue.Enqueue("CheckToCreateIncidentWorker", []interface{}{evt.CheckID(), string(payload)}, "check")
			} else {
				log.Println(err)
				errorlog.Capture(err)
			}

			// Now write to InfluxDB
			bp, _ := client.NewBatchPoints(client.BatchPointsConfig{
				Database:  s.config.DB,
				Precision: "s",
			})

			// Create a point and add to batch
			tags := map[string]string{"check_id": evt.CheckID(), "check_type": evt.CheckType()}
			fields, err := evt.MetricPayload()
			pt, err := client.NewPoint("check_response", tags, fields, time.Now())
			if err != nil {
				log.Println("Error: ", err.Error())
				errorlog.Capture(err)
				continue
			}
			bp.AddPoint(pt)

			// Write the batch
			s.influxClient.Write(bp)
		case <-s.Done:
			break
		}
	}
}
