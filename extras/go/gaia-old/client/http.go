package client

import (
	"fmt"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	nrgorilla "github.com/newrelic/go-agent/_integrations/nrgorilla/v1"
	"github.com/notyim/gaia/apm"
	"github.com/notyim/gaia/types"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
	"time"
)

type HTTPServer struct {
	r       *mux.Router
	scanner *Scanner
}

// Handle register a new check on http interface
func (h *HTTPServer) BulkChecks(w http.ResponseWriter, r *http.Request) {
	b, e := ioutil.ReadAll(r.Body)
	if e != nil {
		// return right header
		fmt.Fprintf(w, "Cannot process request")
		return
	}

	rawCheck := strings.Split(string(b), "\n")
	log.Println("Check Payload", rawCheck)

	h.scanner.DoMulti(rawCheck)
	w.WriteHeader(http.StatusAccepted)
	fmt.Fprintf(w, "OK")
}

// Handle register a new check on http interface
func (h *HTTPServer) RegisterCheck(w http.ResponseWriter, r *http.Request) {
	id := r.FormValue("id")
	uri := r.FormValue("uri")
	checkType := r.FormValue("type")
	check := types.Check{id, uri, checkType, time.Duration(30) * time.Second}
	h.scanner.AddCheck(&check)

	w.WriteHeader(http.StatusAccepted)
	fmt.Fprintf(w, "OK")
}

// Run the whole client
// Register route, initalize client, syncing
func CreateHTTPServer(scanner *Scanner) *HTTPServer {
	s := HTTPServer{
		scanner: scanner,
		r:       mux.NewRouter(),
	}

	s.r.HandleFunc("/checks", s.RegisterCheck).Methods("POST")
	s.r.HandleFunc("/bulkchecks", s.BulkChecks).Methods("POST")

	instrumentRouter := nrgorilla.InstrumentRoutes(s.r, apm.NewrelicApp)
	loggedRouter := handlers.LoggingHandler(os.Stdout, instrumentRouter)
	log.Println(http.ListenAndServe("0.0.0.0:28302", loggedRouter))
	return &s
}
