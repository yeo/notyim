package client

import (
	"net/http"
	"time"
)

func createRequestClient() *http.Client {
	tr := &http.Transport{
		MaxIdleConns:    10,
		IdleConnTimeout: 30 * time.Second,
	}
	return &http.Client{Transport: tr, Timeout: 5 * time.Second}
}
