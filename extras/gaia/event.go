package gaia

import (
	"time"

	"github.com/notyim/gaia/dao"
	"github.com/notyim/gaia/scanner/httpscanner"
	"github.com/notyim/gaia/scanner/tcpscanner"
)

type EventType int

const (
	EventTypeCheckInsert EventType = iota
	EventTypeCheckReplace
	EventTypeCheckDelete
)

const (
	EventTypeRunCheck = iota + 1000
	EventTypeCheckHTTPResult
	EventTypeBeat
	EventTypeCheckTCPResult
)

const (
	EventTypePing = iota + 2000
)

type EventCheckInsert struct {
	EventType EventType
	*dao.Check
}

type EventCheckReplace struct {
	EventType EventType
	*dao.Check
}

type EventCheckDelete struct {
	EventType EventType
	*dao.Check
}

type EventCheckHTTPResult struct {
	EventType EventType
	ID        string
	Agent     string
	Region    string
	Result    *httpscanner.CheckResponse
}

func (e *EventCheckHTTPResult) ToMetric() map[string]interface{} {
	return map[string]interface{}{
		"NameLookup":    e.Result.Timing.NameLookup,
		"Connect":       e.Result.Timing.Connect,
		"TLSHandshake":  e.Result.Timing.TLSHandshake,
		"StartTransfer": e.Result.Timing.StartTransfer,
		"Total":         e.Result.Timing.Total,
	}
}

type EventCheckTCPResult struct {
	EventType EventType
	ID        string
	Agent     string
	Region    string
	Result    *tcpscanner.CheckResponse
}

type EventCheckBeat struct {
	EventType EventType
	ID        string
	Action    string
	BeatAt    time.Time
}

type EventRunCheck struct {
	EventType EventType
	ID        string
}

type EventPing struct {
	EventType EventType
	At        time.Time
}

func NewEventPing() *EventPing {
	return &EventPing{EventType: EventTypePing}
}
