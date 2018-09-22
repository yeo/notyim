package rethinkdb

import (
	r "github.com/dancannon/gorethink"

	"fmt"
	"github.com/notyim/gaia/config"
	"github.com/notyim/gaia/monitor/core"
	"github.com/notyim/gaia/types"
	"log"
	"os"
	"time"
)

const (
	// FlushThreshold is the point we need to reach before flushing to storage
	// a smaller value mean more frequently write
	FlushThreshold = 5
)

type doc types.RethinkService
type buffer []*doc

type Writer struct {
	DataChan chan *core.HTTPMetric
	Size     int
	session  *r.Session
	config   *config.Config
}

func uuid() string {
	f, _ := os.Open("/dev/urandom")
	b := make([]byte, 16)
	f.Read(b)
	f.Close()
	uuid := fmt.Sprintf("%x-%x-%x-%x-%x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:])
	return uuid
}

// NewWriter creates a flusher struct
func NewWriter(config *config.Config) *Writer {
	f := &Writer{
		config: config,
	}
	f.Size = 1000
	f.DataChan = make(chan *core.HTTPMetric, f.Size)
	s, err := f.connect()
	if err != nil {
		log.Fatalln("Cannot connec to RethinkDB", err.Error())
	}
	s.SetMaxOpenConns(10)
	f.session = s

	return f
}

func (w *Writer) connect() (*r.Session, error) {
	return r.Connect(r.ConnectOpts{
		Address:  fmt.Sprintf("%s:%s", w.config.RethinkDBHost, w.config.RethinkDBPort),
		Database: w.config.RethinkDBName,
		MaxIdle:  10,
		MaxOpen:  10,
		Username: w.config.RethinkDBUser,
		Password: w.config.RethinkDBPass,
	})
}

func (w *Writer) reconnect() error {
	s, err := w.connect()
	if err == nil {
		w.session = s
		return nil
	}
	return err
}

func (w *Writer) Name() string {
	return "InfluxDB"
}

func (w *Writer) Write(point *core.HTTPMetric) {
	log.Println("Implement this")
}

func (w *Writer) WriteBatch(points []*core.HTTPMetric) (int, error) {
	defer func() {
		if r := recover(); r != nil {
			// @TODO Reporting
			log.Printf("Fail to flush to RethinkDB %v", r)
			if err := w.reconnect(); err != nil {
				log.Printf("Still fail to connect to RethinkDB")
			}
		}
	}()

	bufferPoints := make(buffer, FlushThreshold, FlushThreshold)
	for i, p := range points {
		log.Printf("Got data %v", p.Response.Status)

		bufferPoints[i] = &doc{
			Duration:  float64(p.Response.Duration / time.Millisecond),
			Status:    p.Response.Status,
			Body:      p.Response.Body,
			ServiceId: p.Service.ID,
			ID:        p.Service.ID,
			Error:     p.Response.Error,
			CreatedAt: r.Now(),
		}
	}

	res, err := r.Table("http_response").
		Insert(bufferPoints,
			r.InsertOpts{
				Conflict: "replace",
			}).Run(w.session)
	defer res.Close()

	if err != nil {
		log.Printf("Fail to flush to RethinkDB %s %v", w.config.InfluxdbHost, err)
		return 0, err
	} else {
		log.Printf("Flush %d points to RethinkDB", len(points))
	}
	return len(points), nil
}
