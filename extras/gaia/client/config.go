package client

import (
	"os"
)

type Config struct {
	GaiaAddr string

	WorkerPool int
}

func LoadConfig() *Config {
	c := Config{
		GaiaAddr:   "localhost:28300",
		WorkerPool: 128,
	}

	if os.Getenv("GAIA_ADDR") != "" {
		c.GaiaAddr = os.Getenv("GAIA_ADDR")
	}

	return &c
}
