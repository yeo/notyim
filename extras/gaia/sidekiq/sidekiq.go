package sidekiq

import (
	"crypto/rand"
	"encoding/json"
	"fmt"
	"io"
	"time"

	"github.com/go-redis/redis/v7"
)

var client redis.Client

type Client struct {
	*redis.Client
}

type Job struct {
	Class      string      `json:"class"`
	ID         string      `json:"jid"`
	Args       interface{} `json:"args"`
	CreatedAt  time.Time   `json:"created_at"`
	EnqueuedAt time.Time   `json:"enqueued_at"`
}

type Config struct {
	Addr string
	DB   int
}

func NewClient(cfg *Config) *Client {
	c := Client{}
	c.Client = redis.NewClient(&redis.Options{
		Addr: cfg.Addr,
		DB:   cfg.DB,
	})

	return &c
}

type Queue string

func generateJid() (string, error) {
	// Return 12 random bytes as 24 character 	hex
	b := make([]byte, 12)
	_, err := io.ReadFull(rand.Reader, b)

	if err != nil {
		return "", fmt.Errorf("Cannot generate job id %w", err)
	}

	return fmt.Sprintf("%x", b), nil
}

func NewJob(class string, args interface{}, retry int) (*Job, error) {
	jobID, err := generateJid()
	if err != nil {
		return nil, fmt.Errorf("Cannot generate job: %w", err)
	}

	j := Job{
		Class:      class,
		CreatedAt:  time.Now(),
		ID:         jobID,
		EnqueuedAt: time.Now(),
		Args:       args,
	}

	return &j, nil
}

func (q Queue) Name() string {
	return "queue:" + string(q)
}

func (c *Client) Enqueue(name string, args interface{}, queue Queue) (*Job, error) {
	// 10 times retry by default
	job, err := NewJob(name, args, 10)
	if err != nil {
		return nil, fmt.Errorf("Fail to enqueue job: %w", err)
	}

	var payload []byte
	payload, err = json.Marshal(job)

	c.Client.LPush(queue.Name(), payload)

	return job, nil
}
