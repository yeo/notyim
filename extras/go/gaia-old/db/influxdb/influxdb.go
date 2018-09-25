package influxdb

import (
	"github.com/influxdata/influxdb/client/v2"
	"log"
)

var (
	db        client.Client
	defaultDb string
)

func Connect(addr, username, password string) {
	c, err := client.NewHTTPClient(client.HTTPConfig{
		Addr:     addr,
		Username: username,
		Password: password,
	})
	if err != nil {
		log.Println("Fail to init infuxdb connection", err)
	}

	db = c
}

func Client() client.Client {
	return db
}

func UseDB(name string) {
	defaultDb = name
}

// Write a single point
func WritePoint(point *client.Point) error {
	points := []*client.Point{point}
	return WritePoints(points)
}

// Write multiple points at a time
func WritePoints(points []*client.Point) error {
	bp, err := client.NewBatchPoints(client.BatchPointsConfig{
		Database:  defaultDb,
		Precision: "us",
	})

	if err != nil {
		log.Println("Failt to create batch point", err)
		return err
	}

	for _, point := range points {
		bp.AddPoint(point)
	}

	return db.Write(bp)
}
