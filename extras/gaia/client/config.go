package client

import (
	"os"
)

type Config struct {
	GaiaAddr  string
	GaiaToken string

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
	if os.Getenv("GAIA_TOKEN") != "" {
		c.GaiaToken = os.Getenv("GAIA_TOKEN")
	}
	return &c
}
