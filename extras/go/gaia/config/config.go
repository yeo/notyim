package config

import (
	"os"
)

// Config struct hold whole configuration
type Config struct {
	Debug bool

	AppHost     string
	AppApiToken string

	InfluxdbHost     string
	InfluxdbUsername string
	InfluxdbPassword string
	InfluxdbDb       string

	MongodbUri string

	GaiaServer      string
	GaiaBindAddress string
}

// NewConfig creates a configuration struct with a sane default value
func NewConfig() *Config {
	c := &Config{
		Debug: false,
	}

	if val := os.Getenv("APP_HOST"); val != "" {
		c.AppHost = val
	} else {
		c.AppHost = "http://noty.ax:9001/api/v1"
	}

	if val := os.Getenv("APP_API_TOKEN"); val != "" {
		c.AppApiToken = val
	} else {
		c.AppApiToken = ""
	}

	if val := os.Getenv("INFLUXDB_HOST"); val != "" {
		c.InfluxdbHost = val
	} else {
		c.InfluxdbHost = "http://127.0.0.1:8086"
	}

	if val := os.Getenv("INFLUXDB_USERNAME"); val != "" {
		c.InfluxdbUsername = val
	} else {
		c.InfluxdbUsername = "noty"
	}

	if val := os.Getenv("INFLUXDB_PASSWORD"); val != "" {
		c.InfluxdbPassword = val
	} else {
		c.InfluxdbPassword = "noty"
	}

	if val := os.Getenv("INFLUXDB_DB"); val != "" {
		c.InfluxdbDb = val
	} else {
		c.InfluxdbDb = "noty"
	}

	if val := os.Getenv("GAIA_SERVER"); val != "" {
		c.GaiaServer = val
	} else {
		c.GaiaServer = "127.0.0.1:19283"
	}

	if val := os.Getenv("GAIA_BIND_ADDRESS"); val != "" {
		c.GaiaBindAddress = val
	} else {
		c.GaiaBindAddress = "127.0.0.1:19283"
	}

	if val := os.Getenv("MONGODB_URI"); val != "" {
		c.MongodbUri = val
	} else {
		c.MongodbUri = "mongo://127.0.0.1/trinity_development"
	}

	return c
}
