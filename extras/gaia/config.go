package gaia

import (
	"os"
)

type Config struct {
	AppEnv      string
	MongoURI    string
	MongoDBName string
}

func LoadConfig() *Config {
	c := Config{
		AppEnv:      "development",
		MongoDBName: "trinity_development",
	}

	c.MongoURI = os.Getenv("MONGO_URI")
	if c.MongoURI == "" {
		c.MongoURI = "mongodb://localhost:27017"
	}

	if os.Getenv("MONGO_DBNAME") != "" {
		c.MongoDBName = os.Getenv("MONGO_DBNAME")
	}

	return &c
}
