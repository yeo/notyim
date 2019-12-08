package client

import (
	"os"
)

type Config struct {
	GaiaAddr   string
	GaiaApiKey string

	WorkerPool int
}

func LoadConfig() *Config {
	c := Config{
		GaiaAddr:   "localhost:28300",
		GaiaApiKey: "banhmitrung",
		WorkerPool: 128,
	}

	if os.Getenv("GAIA_ADDR") != "" {
		c.GaiaAddr = os.Getenv("GAIA_ADDR")
	}
	if os.Getenv("GAIA_APIKEY") != "" {
		c.GaiaApiKey = os.Getenv("GAIA_APIKEY")
	}
	return &c
}
