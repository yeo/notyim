package gaia

import (
	"encoding/json"
	"fmt"
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
	EventType EventType `json:"event_type"`
	*dao.Check
}

type EventCheckReplace struct {
	EventType EventType `json:"event_type"`
	*dao.Check
}

type EventCheckDelete struct {
	EventType EventType `json:"event_type"`
	*dao.Check
}

type EventCheckHTTPResult struct {
	EventType EventType `json:"event_type"`
	ID        string
	IP        string
	Region    string
	Result    *httpscanner.CheckResponse
}

func (e *EventCheckHTTPResult) MetricPayload() (map[string]interface{}, error) {
	return map[string]interface{}{
		"body_size":          len(e.Result.Body),
		"error":              e.Result.Error,
		"from_ip":            e.IP,
		"from_region":        e.Region,
		"status":             e.Result.Status,
		"status_code":        e.Result.StatusCode,
		"time_NameLookup":    e.Result.Timing.NameLookup,
		"time_Connect":       e.Result.Timing.Connect,
		"time_TLSHandshake":  e.Result.Timing.TLSHandshake,
		"time_StartTransfer": e.Result.Timing.StartTransfer,
		"time_Total":         e.Result.Timing.Total,
	}, nil
}

func (e *EventCheckHTTPResult) CheckID() string {
	return e.ID
}

func (e *EventCheckHTTPResult) CheckType() string {
	return "http"
}

func (e *EventCheckHTTPResult) QueuePayload() ([]byte, error) {
	payload, err := json.Marshal(e.Result)
	if err != nil {
		return nil, fmt.Errorf("Cannot encode json %w", err)
	}

	return payload, nil
}

type EventCheckTCPResult struct {
	EventType EventType `json:"event_type"`
	ID        string
	IP        string
	Region    string
	Result    *tcpscanner.CheckResponse
}

func (e *EventCheckTCPResult) MetricPayload() (map[string]interface{}, error) {
	m := map[string]interface{}{
		"error":       e.Result.Error,
		"from_ip":     e.IP,
		"from_region": e.Region,
		"port_open":   e.Result.PortOpen,
	}

	if e.Result.Timing {
		m["time_Total"] = e.Result.Timing.Total
	}

	return m, nil
}

func (e *EventCheckTCPResult) QueuePayload() ([]byte, error) {
	payload, err := json.Marshal(e.Result)
	if err != nil {
		return nil, fmt.Errorf("Cannot encode json %w", err)
	}

	return payload, nil
}

func (e *EventCheckTCPResult) CheckID() string {
	return e.ID
}

func (e *EventCheckTCPResult) CheckType() string {
	return "tcp"
}

type EventCheckBeat struct {
	EventType EventType `json:"event_type"`
	ID        string
	Action    string
	BeatAt    time.Time
}

func (e *EventCheckBeat) BeatType() string {
	if e.Action == "" {
		return "_na_"
	}

	return e.Action
}

func (e *EventCheckBeat) CheckID() string {
	return e.ID
}

func (e *EventCheckBeat) CheckType() string {
	return "beat"
}

func (e *EventCheckBeat) QueuePayload() ([]byte, error) {
	payload := `{"action":"` + e.BeatType() + `"}`

	return []byte(payload), nil
}

func (e *EventCheckBeat) MetricPayload() (map[string]interface{}, error) {
	return map[string]interface{}{
		"action": e.BeatType(),
	}, nil
}

type EventRunCheck struct {
	EventType EventType `json:"event_type"`
	ID        string
}

type EventPing struct {
	EventType EventType `json:"event_type"`
	At        time.Time
}

func NewEventPing() *EventPing {
	return &EventPing{EventType: EventTypePing}
}
