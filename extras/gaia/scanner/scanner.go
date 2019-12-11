package scanner

import (
	"context"
	"encoding/json"
	"io/ioutil"
	"log"
	"net"
	"net/http"
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

func checkHTTP(check *dao.Check, agent MetricWriter) {
	t0 := time.Now()
	defer func() {
		log.Printf("Check %s finish in %v", check.URI, time.Now().Sub(t0))

	}()
	req, err := http.NewRequest("GET", check.URI, nil)
	if err != nil {
		log.Println("Error creating http request for")
		return
	}

	req.Header.Set("User-Agent", "noty/2.0 (https://noty.im)")
	var result httpscanner.Result
	var cancel context.CancelFunc
	ctx := httpscanner.WithHTTPStat(req.Context(), &result)
	ctx, cancel = context.WithCancel(ctx)
	time.AfterFunc(30*time.Second, func() {
		cancel()
	})

	req = req.WithContext(ctx)

	httpClient := &http.Client{
		Timeout: 30 * time.Second,
		Transport: &http.Transport{
			Dial: (&net.Dialer{
				Timeout:   30 * time.Second,
				KeepAlive: 30 * time.Second,
			}).Dial,
			TLSHandshakeTimeout:   10 * time.Second,
			ResponseHeaderTimeout: 10 * time.Second,
			ExpectContinueTimeout: 1 * time.Second,
		},

		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			// always refuse to formatllow redirects,
			return http.ErrUseLastResponse
		},
	}

	res, err := httpClient.Do(req)
	if res != nil {
		defer res.Body.Close()
	}
	if err != nil {
		log.Println("Error when perform http check request")
		return
	}
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Println("Cannot read body", err)
		return
	}
	result.End(time.Now())

	metric := &httpscanner.CheckResponse{
		RunAt:         time.Now(),
		StatusCode:    res.StatusCode,
		Status:        res.Status,
		ContentLength: res.ContentLength,
		Header:        res.Header,
		Timing:        result.ToCheckTiming(),
		Body:          string(body),
	}

	//log.Printf("Response metric %v\n", metric)
	log.Printf("Timing %v", result.Durations())

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
