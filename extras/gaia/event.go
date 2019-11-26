package gaia

import (
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

type Event interface {
	visit(v EventVisitor)
}

type EventVisitor struct {
	visitInsert  func(*EventCheckInsert)
	visitReplace func(*EventCheckReplace)
	visitDelete  func(*EventCheckDelete)
	visitResull  func(*EventCheckResult)
	visitExecute func(*EventRunCheck)
}

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
}

type EventRunCheck struct {
	EventType EventType
	ID        string
}

type EventPing struct {
	EventType EventType
}

func NewEventPing() *EventPing {
	return &EventPing{EventType: EventTypePing}
}
