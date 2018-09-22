package mongo

import (
	"gopkg.in/mgo.v2"
	"log"
)

var (
	session   *mgo.Session
	defaultDB string
)

func Connect(host string, db string) {
	var err error
	session, err = mgo.Dial(host)

	if err != nil {
		panic(err)
	}

	session.DB(db)
	defaultDB = db
}

func Close() {
	session.Close()
}

// Get a session of db so we can run query on it
func GetSession() *mgo.Session {
	return session.Copy()
}

func Query(q func(*mgo.Database) error) error {
	s := session.Copy() //.DB(defaultDB)
	defer s.Close()
	return q(s.DB(defaultDB))
}

func QueryOn(db string, q func(*mgo.Database) error) error {
	s := session.Copy() //.DB(defaultDB)
	defer s.Close()
	log.Println("Query on", db)
	return q(s.DB(db))
}
