package writer

import (
	"github.com/notyim/gaia/config"
	"github.com/notyim/gaia/monitor/core"
	"github.com/notyim/gaia/monitor/writer/influxdb"
	"github.com/notyim/gaia/monitor/writer/rethinkdb"
)

// Flusable is an interface all wite has to comply too
type Flushable interface {
	Write(*core.HTTPMetric)
	WriteBatch([]*core.HTTPMetric) (int, error)
	Name() string
}

// RegisterAll registers all writer plugin
func RegisterAll(config *config.Config) []Flushable {
	var ws []Flushable
	ws = make([]Flushable, 10, 10)

	i := influxdb.NewWriter(config)
	ws[0] = i

	r := rethinkdb.NewWriter(config)
	ws[1] = r

	return ws[0:2]
}
