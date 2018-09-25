package types

import (
	r "github.com/dancannon/gorethink"
)

type RethinkService struct {
	ID        string  `gorethink:"id"`
	Duration  float64 `gorethink:"duration"`
	Status    int     `gorethink:"status"`
	Body      string  `gorethink:"body"`
	ServiceId string  `gorethink:"serviceId"`
	Error     error   `gorethink:"error"`
	CreatedAt r.Term  `gorethink:"createdAt"`
}
