package db

import (
	"log"

	"github.com/mongodb/mongo-go-driver/mongo"
)

type Client interface{}

func GetMongoClient(uri string) Client {
	if uri == "" {
		uri = "mongodb://localhost:27017"
	}

	client, err := mongo.NewClient(uri)
	if err != nil {
		log.Fatal(err)
	}

	return client
}
