package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"time"

	"github.com/notyim/gaia/scanner/httpscanner"
	"net/http/httptrace"
)

func main() {
	req, _ := http.NewRequest("GET", "https://axcoto.com", nil)

	trace := &httptrace.ClientTrace{
		DNSStart: func(i httptrace.DNSStartInfo) {
			fmt.Printf("DNS Start O")
		},

		DNSDone: func(dnsInfo httptrace.DNSDoneInfo) {
			fmt.Printf("DNS Info: %+v\n", dnsInfo)
		},
		GotConn: func(connInfo httptrace.GotConnInfo) {
			fmt.Printf("Got Conn: %+v\n", connInfo)
		},
	}
	req = req.WithContext(httptrace.WithClientTrace(req.Context(), trace))

	client := &http.Client{
		Timeout: 30 * time.Second,
		Transport: &http.Transport{
			Dial: (&net.Dialer{
				Timeout:   30 * time.Second,
				KeepAlive: 30 * time.Second,
			}).Dial,
			TLSHandshakeTimeout:   10 * time.Second,
			ResponseHeaderTimeout: 10 * time.Second,
			ExpectContinueTimeout: 10 * time.Second,
		},

		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			// always refuse to formatllow redirects,
			return http.ErrUseLastResponse
		},
	}

	if _, err := client.Do(req); err != nil {
		log.Fatal(err)
	}

	log.Println("\n\n\n===================\n\n\n\n\n\n\n\n")
	m := httpscanner.Check(req)
	fmt.Println(m.Timing)
}
