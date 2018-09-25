package monitor

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	//"net/url"
	"github.com/notyim/gaia/monitor/core"
	"sync"
	"testing"
)

func testTools(code int, body string) *httptest.Server {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(code)
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintln(w, body)
	}))

	//transport := &http.Transport{
	//	Proxy: func(req *http.Request) (*url.URL, error) {
	//		return url.Parse(server.URL)
	//	},
	//}

	//httpClient := &http.Client{Transport: transport}
	//client := &Client{server.URL, httpClient}

	return server
}

func Test_Collect(t *testing.T) {
	out := make(chan *core.HTTPMetric)
	agent, _ := NewAgent(out)
	go agent.Start()

	server := testTools(201, "OK")
	go func() {
		agent.InChan <- core.NewHTTPService(server.URL, "1", 10)
	}()

	agent.Stop()

	var wg sync.WaitGroup
	wg.Add(1)
	go func() {
		r := <-out
		if assert.NotNil(t, r) {
			assert.Equal(t, 201, r.Response.Status)
		}
		defer wg.Done()
	}()
	wg.Wait()
}
