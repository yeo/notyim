package influxdb

import (
	"github.com/influxdb/influxdb/client/v2"
	"github.com/notyim/gaia/config"
	"github.com/notyim/gaia/monitor/core"
	"log"
	"time"
)

type Writer struct {
	DataChan chan *core.HTTPMetric
	Size     int
	client   client.Client
	config   *config.Config
}

// NewWriter creates a flusher struct
func NewWriter(config *config.Config) *Writer {
	f := &Writer{
		config: config,
	}
	c, _ := client.NewHTTPClient(client.HTTPConfig{
		Addr:     config.InfluxdbHost,
		Username: config.InfluxdbUsername,
		Password: config.InfluxdbPassword,
	})
	f.client = c

	return f
}

func (w *Writer) Name() string {
	return "InfluxDB"
}

func (w *Writer) Write(point *core.HTTPMetric) {
	log.Println("Implement this")
}

func (w *Writer) WriteBatch(points []*core.HTTPMetric) (int, error) {
	var bp client.BatchPoints
	bp, _ = client.NewBatchPoints(client.BatchPointsConfig{
		Database:  w.config.InfluxdbDb,
		Precision: "s",
	})

	for _, p := range points {
		log.Printf("Got data %v", p.Response.Status)

		tags := map[string]string{
			"ServiceId": p.Service.ID,
		}
		fields := map[string]interface{}{
			"Duration": float64(p.Response.Duration / time.Millisecond),
			"Status":   p.Response.Status,
			//@TODO find a way to also store body in InfluxDB
			// without huring performance
			//"Body":     p.Response.Body,
		}

		if nil != p.Response.Error {
			fields["Error"] = p.Response.Error
		}

		pt, _ := client.NewPoint("http_response", tags, fields, time.Now())
		bp.AddPoint(pt)

		//pb, _ := client.NewPoint("http_response_body", tags, fields, time.Now())
		//bp.AddPoint(pt)
	}

	if err := w.client.Write(bp); err != nil {
		log.Printf("Fail to flush to InfluxDB %s %v", w.config.InfluxdbHost, err)
		return 0, err
	} else {
		log.Printf("Flush %d points to InfluxDB", len(points))
	}
	return len(points), nil
}
