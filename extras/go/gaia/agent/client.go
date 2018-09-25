package agent

import (
	"context"
	"log"
	"os"
	"os/signal"
	//"sync"
	"fmt"
	"syscall"
	"time"

	"github.com/notyim/gaia/config"
	"google.golang.org/grpc"
)

// Client is a controller that coordinate worker process
type Client struct {
	Config         *config.Config
	Worker         *ClientWorker
	CleanupChannel []chan int
}

// Initialize gaia client
func NewClient(c *config.Config) *Client {
	client := Client{
		Config: c,
		Worker: &ClientWorker{
			GaiaServer:  c.GaiaServer,
			WorkerCount: 4, //TODO: dynamically fetch config
		},
		CleanupChannel: make([]chan int, 0),
	}

	return &client
}

// Start initialize client and register signal handler
func (c *Client) Start() {
	log.Println("Starting gaia client, connect to server ", c.Config.GaiaServer)
	c.CleanupChannel = c.Worker.Run()

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	sig := <-sigs
	log.Println("Got user signal", sig)
	c.Shutdown()
	for i, done := range c.CleanupChannel {
		log.Println("Waiting worker", i, "to shutdown")
		<-done
		log.Println("Worker", i, "finished shutdown")
	}
	log.Println("Bye")
}

// Shutdown terminate work process cleanrly
func (c *Client) Shutdown() {
	log.Println("Shutdown gaia client")

	for i, v := range c.CleanupChannel {
		log.Println("Signal worker", i, "to shutdown")
		v <- 1
	}
}

// ClientWorker syncs checks from server, execute and push result back
type ClientWorker struct {
	GaiaServer  string
	WorkerCount int
}

// Run spawns go routine worker
func (w *ClientWorker) Run() []chan int {
	done := make([]chan int, 0)
	for i := 0; i < w.WorkerCount; i = i + 1 {
		done = append(done, make(chan int))
		go w.Perform(done[i], i)
	}
	return done
}

// Shutdown close worker channel and exit go routine
func (w *ClientWorker) Shutdown() {
}

// Perform is the main entry point to register client and perform checks
func (w *ClientWorker) Perform(done chan int, id int) {
	log.Println("Init worker", id)

	// TODO: Add tls for prod
	conn, err := grpc.Dial(w.GaiaServer, grpc.WithInsecure())

	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)

	c := NewGaiaClient(conn)

	req := RegistrationRequest{
		Name: fmt.Sprintf("worker-%d", id),
	}
	res, err := c.Register(ctx, &req)
	log.Println("Response", res.Name)
	cancel()

WorkerLoop:
	for {
		select {
		case <-done:
			break WorkerLoop
		case <-time.After(time.Second * 3):
			log.Println("Worker", id, "Fetch at", time.Now())

			ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
			r := SaveCheckMetricsRequest{
				CheckId: "11",
				Metrics: map[string]float64{
					"dns":      14,
					"connect":  12,
					"response": 200,
				},
			}
			res, err := c.SaveCheckMetrics(ctx, &r)
			if err == nil {
				log.Println("Response", res.Ok)
			} else {
				log.Println(err)
			}
			cancel()
		}
	}

	close(done)
}
