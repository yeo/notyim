package db

import (
	"context"
	"fmt"
	"log"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Client struct {
	*mongo.Client
}

func Connect(uri string) *Client {
	if uri == "" {
		uri = "mongodb://localhost:27017"
	}
	clientOptions := options.Client().SetAppName("gaia").ApplyURI(uri)

	// Connect to MongoDB
	client, err := mongo.Connect(context.TODO(), clientOptions)

	if err != nil {
		log.Fatal(err)
	}

	// Check the connection
	err = client.Ping(context.TODO(), nil)

	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Connected to MongoDB!")

	return &Client{
		Client: client,
	}
}

// Close shutdowns connection of client to mongodb
func Close(c *Client) {
	fmt.Println("TODO")
}
