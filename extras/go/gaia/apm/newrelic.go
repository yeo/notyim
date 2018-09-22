package apm

import (
	"github.com/newrelic/go-agent"
	"os"
)

var NewrelicApp newrelic.Application

func init() {
	config := newrelic.NewConfig("Gaia-"+os.Getenv("GAIA_ENV"), os.Getenv("NEWRELIC_APIKEY"))
	var err error
	NewrelicApp, err = newrelic.NewApplication(config)
	if err != nil {
		panic("Cannot create newrelic")
	}
}
