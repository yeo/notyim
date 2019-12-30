package scanner

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
	"time"

	"github.com/notyim/gaia"
	"github.com/notyim/gaia/dao"
	"github.com/notyim/gaia/errorlog"
	"github.com/notyim/gaia/scanner/httpscanner"
	"github.com/notyim/gaia/scanner/tcpscanner"
)

type MetricWriter interface {
	PushToServer([]byte) error
	IPAddress() string
	Region() string
}

func Check(check *dao.Check, agent MetricWriter) {
	if check.IsHttp() {
		checkHTTP(check, agent)
	}

	if check.IsTCP() {
		checkTCP(check, agent)
	}

	if check.IsBeat() {
	}
}

func checkTCP(check *dao.Check, agent MetricWriter) {
	log.Println("Start to check tcp for", check.URI)
	// In case of tcp check we prefic the uri as tcp://host:port so we need to remove tcp:// part here
	response, err := tcpscanner.Check("tcp", check.URI[6:])
	if err != nil {
		errorlog.Capture(err)
		return
	}

	runResult := gaia.EventCheckTCPResult{
		EventType: gaia.EventTypeCheckTCPResult,
		ID:        check.ID.Hex(),
		IP:        agent.IPAddress(),
		Region:    agent.Region(),
		Result:    response,
	}
	resultPayload, err := json.Marshal(runResult)
	if err != nil {
		errorlog.Capture(err)
		return
	}
	log.Println("Push tcp check result to client", runResult, string(resultPayload))
	agent.PushToServer(resultPayload)
}

func buildHTTPRequest(check *dao.Check) (*http.Request, error) {
	var req *http.Request
	var err error

	req, err = http.NewRequest(check.HttpMethod, check.URI, nil)
	if err != nil {
		return req, err
	}

	if check.Body != "" {
		body := strings.NewReader(check.Body)
		// request Body wants a io.ReadCloser while we had io.Reader
		req.Body = ioutil.NopCloser(body)
	}

	switch check.BodyType {
	case "form":
		req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	case "json":
		req.Header.Set("Content-Type", "application/json")
	}

	if check.RequireAuth {
		req.SetBasicAuth(check.AuthUsername, check.AuthPassword)
	}

	if check.HttpHeaders != nil && len(check.HttpHeaders) >= 1 {
		for k, v := range check.HttpHeaders {
			req.Header.Set(k, v)
		}
	}

	return req, err
}

func checkHTTP(check *dao.Check, agent MetricWriter) {
	t0 := time.Now()
	defer func() {
		// Telegram hook to report abnormal thing
		log.Printf("Check %s finish in %v", check.URI, time.Now().Sub(t0))
	}()

	req, err := buildHTTPRequest(check)

	if err != nil {
		errorlog.Capture(err)
		return
	}

	metric := httpscanner.Check(req)

	runResult := gaia.EventCheckHTTPResult{
		EventType: gaia.EventTypeCheckHTTPResult,
		ID:        check.ID.Hex(),
		IP:        agent.IPAddress(),
		Region:    agent.Region(),
		Result:    metric,
	}
	resultPayload, _ := json.Marshal(runResult)
	agent.PushToServer(resultPayload)
}
