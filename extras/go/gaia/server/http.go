package server

import (
	"encoding/json"
	"fmt"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	nrgorilla "github.com/newrelic/go-agent/_integrations/nrgorilla/v1"
	"github.com/notyim/gaia/apm"
	"github.com/notyim/gaia/client"
	"github.com/notyim/gaia/models"
	"github.com/notyim/gaia/types"
	"log"
	"net/http"
	"os"
	"strings"
	//"strconv"
	"time"
)

type HTTPServer struct {
	server  *Server
	r       *mux.Router
	flusher *Flusher
}

func (h *HTTPServer) Start(bindTo string) {
	instrumentRouter := nrgorilla.InstrumentRoutes(h.r, apm.NewrelicApp)
	loggedrouter := handlers.LoggingHandler(os.Stdout, instrumentRouter)
	if err := http.ListenAndServe(bindTo, loggedrouter); err != nil {
		log.Fatal("Error: Gaia HTTP server error", err)
	}
}

// Handle register a new check on http interface
func (h *HTTPServer) ListCheck(w http.ResponseWriter, r *http.Request) {
	for _, check := range h.server.Checks {
		fmt.Fprintf(w, fmt.Sprintf("%s,%s,%s\n", check.ID.Hex(), check.URI, check.Type))
	}
}

// Register a client to our internal server state
func (h *HTTPServer) ListClient(w http.ResponseWriter, r *http.Request) {
	lines := ""
	for _, c := range h.server.Clients {
		log.Printf("Existing clients %v\n", h.server.Clients)
		lines += fmt.Sprintf("%s: %s Last ping %s\n\n", c.Address.IpAddress, c.Address.Location, c.Lastping)
	}
	fmt.Fprintf(w, lines)
	w.WriteHeader(200)
}

// TODO:  Detect client ip with trusted proxy
func findClientIP(r *http.Request) string {
	proxy := r.RemoteAddr
	log.Println("Proxy", proxy)
	log.Println("Gaia header", r.Header)
	forwardFor := r.Header.Get("X-FORWARDED-FOR")
	if forwardFor == "" {
		if strings.HasPrefix(proxy, "127.0.0.1") == true {
			return "127.0.0.1"
		}
	}
	return forwardFor
}

// Register a client to our internal server state
func (h *HTTPServer) RegisterClient(w http.ResponseWriter, r *http.Request) {
	ip := findClientIP(r)
	log.Println("Detect IP", ip)
	location := r.FormValue("location")

	if ip == "" || location == "" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if c := h.server.findClientByIp(ip); c != nil {
		w.WriteHeader(http.StatusAlreadyReported)
		return
	}

	client := client.Client{
		Lastping: time.Now(),
		Address: types.ClientAddress{
			IpAddress: ip,
			Location:  location,
		},
	}
	h.server.Clients = append(h.server.Clients, &client)

	w.WriteHeader(http.StatusCreated)
}

func (h *HTTPServer) Install(w http.ResponseWriter, r *http.Request) {
	log.Println(types.Version)

	fmt.Fprintf(w, fmt.Sprintf("#!/bin/bash -l\n\nset -xue\n\necho Start Installer\ncurl -sL https://github.com/NotyIm/gaia/releases/download/%s/gaia_amd64.deb -o /tmp/gaia.deb\nsudo dpkg -i /tmp/gaia.deb\nsystemctl enable gaia\nsystemctl start gaia\nrm /tmp/gaia.deb", types.Version))
	w.WriteHeader(http.StatusOK)
}

func (h *HTTPServer) Stats(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Gaia Ok.\nInstall server with.\ncurl -s https://gaia.noty.im/install | bash")
	w.WriteHeader(http.StatusOK)
}

func (h *HTTPServer) CreateCheckResult(w http.ResponseWriter, r *http.Request) {
	checkResult := models.CheckResult{}
	decoder := json.NewDecoder(r.Body)
	err := decoder.Decode(&checkResult)

	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		log.Println("Fail to parse Check Result body", err)
		fmt.Fprintf(w, "Fail to parse Check Result body", err)
		return
	}

	h.flusher.Write(&checkResult)

	w.WriteHeader(http.StatusAccepted)

	go h.server.pingFromIp(findClientIP(r))

	fmt.Fprintf(w, "OK")
}

// gun the whole client
// Register route, initalize client, syncing
func CreateHTTPServer(server *Server, flusher *Flusher) *HTTPServer {
	s := HTTPServer{
		server:  server,
		flusher: flusher,
		r:       mux.NewRouter(),
	}

	s.r.HandleFunc("/", s.Stats).Methods("GET")
	s.r.HandleFunc("/install", s.Install).Methods("GET")
	s.r.HandleFunc("/checks", s.ListCheck).Methods("GET")
	s.r.HandleFunc("/client/register", s.RegisterClient).Methods("POST")
	s.r.HandleFunc("/clients", s.ListClient).Methods("GET")
	s.r.HandleFunc("/check_results/{id}", s.CreateCheckResult).Methods("POST")
	return &s
}
