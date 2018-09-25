package config

import (
	"os"
)

// Config struct hold whole configuration
type Config struct {
	Debug bool

	AppHost     string
	AppApiToken string

	DbHost     string
	DbUser     string
	DbPassword string

	InfluxdbHost     string
	InfluxdbUsername string
	InfluxdbPassword string
	InfluxdbDb       string

	RethinkDBHost string
	RethinkDBPort string
	RethinkDBUser string
	RethinkDBPass string
	RethinkDBName string

	MongoDBName string

	GaiaServerHost   string
	GaiaServerBindTo string
	GaiaClientBindTo string
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

	if val := os.Getenv("DbHost"); val != "" {
		c.DbHost = val
	} else {
		c.DbHost = "127.0.0.1"
	}

	if val := os.Getenv("DbUser"); val != "" {
		c.DbUser = val
	} else {
		c.DbUser = "value"
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

	if val := os.Getenv("RETHINKDB_HOST"); val != "" {
		c.RethinkDBHost = val
	} else {
		c.RethinkDBHost = "127.0.0.1"
	}
	if val := os.Getenv("RETHINKDB_USER"); val != "" {
		c.RethinkDBUser = val
	} else {
		c.RethinkDBUser = "noty"
	}
	if val := os.Getenv("RETHINKDB_PASS"); val != "" {
		c.RethinkDBPass = val
	}
	if val := os.Getenv("RETHINKDB_NAME"); val != "" {
		c.RethinkDBName = val
	} else {
		c.RethinkDBName = "noty"
	}
	if val := os.Getenv("RETHINKDB_PORT"); val != "" {
		c.RethinkDBPort = val
	} else {
		c.RethinkDBPort = "28015"
	}

	if val := os.Getenv("GAIA_SERVER_HOST"); val != "" {
		c.GaiaServerHost = val
	} else {
		c.GaiaServerHost = "127.0.0.1:28301"
	}

	if val := os.Getenv("GAIA_SERVER_BINDTO"); val != "" {
		c.GaiaServerBindTo = val
	} else {
		c.GaiaServerBindTo = "127.0.0.1:28300"
	}

	if val := os.Getenv("GAIA_CLIENT_BINDTO"); val != "" {
		c.GaiaClientBindTo = val
	} else {
		c.GaiaClientBindTo = "127.0.0.1:28302"
	}

	if val := os.Getenv("MONGODB_NAME"); val != "" {
		c.MongoDBName = val
	} else {
		c.MongoDBName = "trinity_development"
	}

	return c
}
