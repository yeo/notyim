package models

import (
	"github.com/notyim/gaia/db/mongo"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"log"
)

type Check struct {
	// identification information
	ID   bson.ObjectId `bson:"_id"`
	URI  string        `bson:"uri"`
	Type string        `bson:"type"`
}

func NewCheck(uri, checkType string) *Check {
	return &Check{
		ID:   bson.NewObjectId(),
		URI:  uri,
		Type: checkType,
	}
}

func (s *Check) FindByID(id bson.ObjectId, db *mgo.Database) error {
	return s.coll(db).FindId(id).One(s)
}

func (*Check) coll(db *mgo.Database) *mgo.Collection {
	return db.C("service")
}

type Checks *[]Check

//func (c *Checks) All() error {
//	return mongo.Query(func(session *mgo.Database) error {
//		var checks []Check
//		session.C("checks").Find(nil).Sort("_id").All(&checks)
//		c = checks
//		log.Println(c)
//		return nil
//	})
//}

func AllChecks(c *[]Check) error {
	return mongo.Query(func(session *mgo.Database) error {
		session.C("checks").Find(nil).Sort("_id").All(c)
		return nil
	})
}

func FindChecksAfter(c *[]Check, id bson.ObjectId) error {
	return mongo.Query(func(session *mgo.Database) error {
		session.C("checks").Find(bson.M{"_id": bson.M{"$gt": bson.ObjectIdHex(id.Hex())}}).Sort("_id").All(c)
		return nil
	})
}

// Find check by split all checks into shard
func FindChecksByShard(c *[]Check, shard int) error {
	return mongo.Query(func(session *mgo.Database) error {
		t, e := session.C("checks").Count()
		log.Println("Total check", t)
		if e == nil {
			limit := t / 10
			if limit < 1 {
				limit = 1
			}
			limit++

			session.C("checks").Find(nil).Skip((shard - 1) * limit).Limit(limit).All(c)
			log.Println("Shard", shard, c)
		}

		return nil
	})
}
