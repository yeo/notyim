package models

import (
	"log"

	"github.com/mongodb/mongo-go-driver/bson"
)

type Check struct {
	ID   bson.ObjectId `bson:"_id"`
	URI  string        `bson:"uri"`
	Type string        `bson:"type"`
}

func NewCheck(uri, checkType string) *Check {
	return &Check{
		URI:  uri,
		Type: checkType,
	}
}
