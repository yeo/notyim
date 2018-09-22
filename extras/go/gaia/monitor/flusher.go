package monitor

import (
	"github.com/influxdb/influxdb/client/v2"
	"github.com/notyim/gaia/config"
	"github.com/notyim/gaia/monitor/core"
	"github.com/notyim/gaia/monitor/writer"
	"log"
	//"time"
)

const (
	// FlushThreshold is the point we need to reach before flushing to storage
	// a smaller value mean more frequently write
	FlushThreshold = 5
)

// Flusher represents a flusher that flushs data to a storage backend
type Flusher struct {
	DataChan chan *core.HTTPMetric
	Size     int
	client   client.Client
	config   *config.Config

	writers []writer.Flushable
}

// NewFlusher creata a flusher struct
func NewFlusher(config *config.Config, c client.Client) *Flusher {
	f := &Flusher{
		config: config,
	}
	f.Size = 1000
	f.DataChan = make(chan *core.HTTPMetric, f.Size)
	if c == nil {
		c, _ = client.NewHTTPClient(client.HTTPConfig{
			Addr:     config.InfluxdbHost,
			Username: config.InfluxdbUsername,
			Password: config.InfluxdbPassword,
		})
	}
	f.client = c

	// Register our writer plugin
	f.writers = writer.RegisterAll(config)

	return f
}

// Start accepts incoming data from its own data channel and flush to backend
func (f *Flusher) Start() {
	var bufferPoints []*core.HTTPMetric
	var totalPoint = 0

	for {
		if totalPoint == 0 {
			bufferPoints = make([]*core.HTTPMetric, FlushThreshold, FlushThreshold)
		}

		r := <-f.DataChan
		bufferPoints[totalPoint] = r
		totalPoint++

		if totalPoint >= FlushThreshold {
			// Create a deep copy of current bufferPoint for flusing in background
			flushPoints := make([]*core.HTTPMetric, totalPoint, FlushThreshold)
			//for i, p := range bufferPoints {
			//	flushPoints[i] = &core.HTTPMetric{
			//		Service: &core.Service{
			//			Address:  p.Service.Address,
			//			ID:       p.Service.ID,
			//			Interval: p.Service.Interval,
			//			Type:     p.Service.Type,
			//		},
			//		Response: core.ResponseMetric{
			//			Body:     p.Response.Body,
			//			Status:   p.Response.Status,
			//			Duration: p.Response.Duration,
			//			Error:    p.Response.Error,
			//		},
			//	}
			//}

			t := copy(flushPoints, bufferPoints)
			log.Printf("Copy %d point for flushing", t)
			log.Printf("Buffer Point %v", bufferPoints)
			log.Printf("Flush Point %v", flushPoints)
			go f.Flush(flushPoints)
			totalPoint = 0
		}
	}
}

// Flush writes metric points to all writer
func (f *Flusher) Flush(points []*core.HTTPMetric) {
	for i, w := range f.writers {
		log.Printf("Start to write to %d:%s writers ", i, w.Name())
		w.WriteBatch(points)
	}
}
