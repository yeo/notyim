package gaia

import (
	"log"
	"os"
	"strconv"

	"github.com/notyim/gaia/sidekiq"
)

type Config struct {
	ApiKey string
	AppEnv string

	MongoURI    string
	MongoDBName string

	*RedisConfig

	*InfluxDBConfig
}

type InfluxDBConfig struct {
	Addr string
	DB   string
}

type RedisConfig struct {
	Addr string
	DB   int
}

func LoadConfig() *Config {
	c := Config{
		ApiKey:      "banhmitrung",
		AppEnv:      "development",
		MongoDBName: "trinity_development",
	}

	if os.Getenv("APIKEY") != "" {
		c.ApiKey = os.Getenv("APIKEY")
	}

	if os.Getenv("APPENV") != "" {
		c.AppEnv = os.Getenv("APPENV")
	}

	c.MongoURI = os.Getenv("MONGO_URI")
	if c.MongoURI == "" {
		c.MongoURI = "mongodb://localhost:27017"
	}

	if os.Getenv("MONGO_DBNAME") != "" {
		c.MongoDBName = os.Getenv("MONGO_DBNAME")
	}

	redisConfig := &RedisConfig{Addr: "localhost:6379", DB: 0}
	if os.Getenv("REDIS_ADDR") != "" {
		redisConfig.Addr = os.Getenv("REDIS_ADDR")
	}

	if os.Getenv("REDIS_DB") != "" {
		redisConfig.DB, _ = strconv.Atoi(os.Getenv("REDIS_DB"))
	}
	c.RedisConfig = redisConfig

	influxdbConfig := &InfluxDBConfig{Addr: "http://localhost:8086", DB: "noty_development"}
	if os.Getenv("INFLUXDB_HOST") != "" {
		influxdbConfig.Addr = os.Getenv("INFLUXDB_HOST")
	}
	if !c.IsDev() {
		influxdbConfig.DB = "noty_production"
	}
	c.InfluxDBConfig = influxdbConfig
	log.Println("Loaded config", c)

	return &c
}

func (c *Config) Redis() *sidekiq.Config {
	return &sidekiq.Config{
		Addr: c.RedisConfig.Addr,
		DB:   c.RedisConfig.DB,
	}
}

func (c *Config) Sink() *SinkConfig {
	return &SinkConfig{
		Addr: c.InfluxDBConfig.Addr,
		DB:   c.InfluxDBConfig.DB,
	}
}

func (c *Config) IsDev() bool {
	return c.AppEnv == "development"
}
