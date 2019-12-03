package tcpscanner

import (
	"log"
	"net"
	"strings"
	"time"

	"github.com/notyim/gaia/errorlog"
)

const (
	maxTimeout = 30
)

type CheckResponse struct {
	PortOpen     bool         `json:"port_open"`
	Body         string       `json:"body"`
	Timing       *CheckTiming `json:"timing"`
	Error        bool         `json:"error"`
	ErrorMessage string       `json:"error_message"`
}

type CheckTiming struct {
	NameLookup time.Duration `json:"name_lookup"`
	Connect    time.Duration `json:"connect"`
	Total      time.Duration `json:"total"`
}

func Check(protocol, hostport string) (*CheckResponse, error) {
	var t0, t1 time.Time
	t0 = time.Now()
	log.Println("Attempt to dial", protocol, hostport)
	conn, err := net.DialTimeout(protocol, hostport, maxTimeout*time.Second)
	t1 = time.Now()

	if err != nil {
		if strings.Contains(err.Error(), "too many open files") {
			// This is our own error, we report to sentry
			errorlog.Capture(err)
			return nil, err
		}

		return &CheckResponse{
			PortOpen:     false,
			Error:        true,
			ErrorMessage: err.Error(),
		}, nil
	}

	defer conn.Close()

	//TODO: Enable this once we support body
	//buf := []byte{}
	//readLimit := 1 * 1024
	//maxbytes := 8 * 1024
	//readBytes := 0
	//conn.SetReadDeadline(time.Now().Add(5 * time.Second))

	//for {
	//	tmpBuf := make([]byte, readLimit)
	//	log.Println("Read byte from server", hostport)
	//	i, err := conn.Read(tmpBuf)
	//	if i > 0 {
	//		buf = append(buf, tmpBuf[:i]...)
	//		readBytes += i
	//		if i < readLimit || (maxbytes > 0 && maxbytes <= readBytes) {
	//			break
	//		}
	//	}

	//	if err == io.EOF || err == net.OpError {
	//		break
	//	}

	//	if err != nil {
	//		errorlog.Capture(err)
	//		break
	//	}
	//}

	response := &CheckResponse{
		Body:     "",
		PortOpen: true,
		Error:    false,
		Timing: &CheckTiming{
			Connect: t1.Sub(t0),
			Total:   time.Now().Sub(t0),
		},
	}

	log.Println("TCP Response", response)
	return response, nil
}
