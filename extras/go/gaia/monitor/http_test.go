package monitor

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	//"net/url"
	"github.com/notyim/gaia/monitor/core"
	//"sync"
	//"testing"
)

// HTTPServer represents internal http server
type HTTPServer struct {
	agent *Agent
	r     *mux.Router
}

// NewHTTPServer create a HttpServer struct
func NewHTTPServer(agent *Agent) *HTTPServer {
	s := &HTTPServer{
		agent: agent,
		r:     mux.NewRouter(),
	}

	stat := stats.New()

	//Wrap the main function into stats handler
	s.r.Handle("/", stat.Handler(http.HandlerFunc(index)))

	// Route to expose stats
	h := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		s, err := json.Marshal(stat.Data())
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
		w.Write(s)
	})
	s.r.HandleFunc("/_stats", h)

	s.r.NotFoundHandler = stat.Handler(http.HandlerFunc(notFound))

	return s
}

// Start run http server
func (s *HTTPServer) Start() {
	log.Printf("Start server bootstrap")
	bind := "127.0.0.1:23501"
	if cbind := os.Getenv("BIND"); cbind != "" {
		bind = cbind
	}
	log.Println(http.ListenAndServe(bind, s.r))
	log.Printf("Finish server bootstrap")
}

func index(resp http.ResponseWriter, req *http.Request) {
	fmt.Fprintln(resp, "Gaia is running")
}

func notFound(resp http.ResponseWriter, req *http.Request) {
	fmt.Fprintln(resp, "Gaia isn't able to serve your request")
	resp.WriteHeader(http.StatusNotFound)
}
