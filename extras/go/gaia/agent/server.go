package agent

import (
	"context"
	"log"
	"net"

	"github.com/notyim/gaia/config"
	"google.golang.org/grpc"
	"google.golang.org/grpc/peer"
)

// ServerWorker is the worker process handle Gaia Sever logic
type ServerWorker struct {
}

// Server coordinates worker process
type Server struct {
	Config          *config.Config
	Grpc            *grpc.Server
	GaiaServer      *ServerWorker
	ConnectedClient map[string]string
}

// Initialize gaia server
func NewServer(c *config.Config) *Server {
	server := Server{
		Config:     c,
		Grpc:       grpc.NewServer(),
		GaiaServer: &ServerWorker{},
	}

	RegisterGaiaServer(server.Grpc, server.GaiaServer)

	return &server
}

// Start initialize gaia grpc server
func (s *Server) Start() {
	log.Println("Starting gaia server")
	log.Println("Initalize server and bind to", s.Config.GaiaBindAddress)
	log.Println("Bind GRPC server to ", s.Config.GaiaBindAddress)

	if lis, err := net.Listen("tcp", s.Config.GaiaBindAddress); err == nil {
		s.Grpc.Serve(lis)
	} else {
		log.Println("Error when binding server", err)
	}
}

// Shutdown cleanly close server
func (s *Server) Shutdown() {
	log.Println("Shutdown gaia server")
}

// Register handle client request to gaia
func (g *ServerWorker) Register(c context.Context, r *RegistrationRequest) (*RegistrationResponse, error) {
	log.Println(r.String())

	p, ok := peer.FromContext(c)
	if ok == true {
		log.Println("Request from", p.Addr)
	}
	return &RegistrationResponse{
		Name: "This is server acknow",
	}, nil
}

// SyncCheck sync checks from gaia back to client
func (g *ServerWorker) SyncCheck(c context.Context, r *SyncCheckRequest) (*SyncCheckResponse, error) {
	return nil, nil
}

// SyncCheckMetrics store the check metrics into our storage
func (g *ServerWorker) SaveCheckMetrics(context.Context, *SaveCheckMetricsRequest) (*SaveCheckMetricsResponse, error) {
	return &SaveCheckMetricsResponse{
		Ok: true,
	}, nil
}
