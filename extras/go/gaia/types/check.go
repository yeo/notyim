package types

import (
	"time"
)

type Check struct {
	ID       string
	URI      string
	Type     string
	Interval time.Duration
}

type HTTPCheckResponse struct {
	FromRegion    string                   `json:"from_region"` // region where this is run
	FromIp        string                   `json:"from_ip"`     // client ip where this is run
	CheckedAt     time.Time                `json:"checked_at"`
	CheckID       string                   `json:"check_id"`
	Time          map[string]time.Duration `json:"time"`
	Body          string                   `json:"body"`
	Http          map[string]string        `json:"http"`
	Headers       map[string]string        `json:"headers"`
	Tcp           map[string]string        `json:"tcp"`
	Error         bool                     `json:"error"`
	ErrorMessage  string                   `json:"error_message"`
	ContentLength int64                    `json:"content_length"` // length of body
	StatusCode    int                      `json:"status_code"`    // status code
	Status        string                   `json:"status"`         // status code
}
