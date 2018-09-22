package env

import (
	"fmt"
	r "github.com/dancannon/gorethink"
	"github.com/influxdb/influxdb/client/v2"
	"github.com/notyim/gaia/config"
	"github.com/oschwald/geoip2-golang"
	"log"
	"net"
)

const (
	MaxRethinkDBConnection = 50
)

type Env struct {
	Config   *config.Config
	Influx   client.Client
	Rethink  *r.Session
	Location struct {
		Country string
	}
}

var (
	app *Env
)

func NewEnv() *Env {
	config := config.NewConfig()
	app = &Env{
		Config: config,
	}

	app.initInflux()
	app.initRethink()
	return app
}

func GetEnv() *Env {
	return app
}

func (e *Env) initInflux() error {
	c, err := client.NewHTTPClient(client.HTTPConfig{
		Addr:     e.Config.InfluxdbHost,
		Username: e.Config.InfluxdbUsername,
		Password: e.Config.InfluxdbPassword,
	})
	if err != nil {
		return err
	}
	e.Influx = c
	return nil
}

func (e *Env) initRethink() error {
	session, err := r.Connect(r.ConnectOpts{
		Address:  fmt.Sprintf("%s:%s", e.Config.RethinkDBHost, e.Config.RethinkDBPort),
		Database: e.Config.RethinkDBName,
		MaxIdle:  MaxRethinkDBConnection * 2,
		MaxOpen:  MaxRethinkDBConnection * 2,
		Username: e.Config.RethinkDBUser,
		Password: e.Config.RethinkDBPass,
	})
	if err != nil {
		log.Fatalf("Cannot connect to RethinkDB %s", err)
		return err
	}

	session.SetMaxOpenConns(MaxRethinkDBConnection)
	e.Rethink = session
	return nil
}

func (e *Env) initLocation() error {

	db, err := geoip2.Open("data/GeoIP2-City.mmdb")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	// If you are using strings that may be invalid, check that ip is not nil
	ip := net.ParseIP("81.2.69.142")
	record, err := db.Country(ip)
	if err != nil {
		log.Fatal(err)
	}
	e.Location = struct {
		Country string
	}{record.Country.IsoCode}
	return nil
}
