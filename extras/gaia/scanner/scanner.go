package scanner

import (
	"encoding/json"
	"log"
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
		// Telegram hook to report abnormal thing
		log.Printf("Check %s finish in %v", check.URI, time.Now().Sub(t0))
	}()
	req, err := http.NewRequest("GET", check.URI, nil)
	if err != nil {
		log.Println("Error creating http request for")
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
