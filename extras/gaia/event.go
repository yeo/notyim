package gaia

import (
	"time"

	"github.com/notyim/gaia/dao"
)

type EventType int

const (
	EventTypeCheckInsert EventType = iota
	EventTypeCheckReplace
	EventTypeCheckDelete
)
const (
	EventTypeRunCheck = iota + 1000
	EventTypeCheckResult
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

type EventCheckResult struct {
	EventType EventType
	ID        string
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
