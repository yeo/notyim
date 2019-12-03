package dao

import (
	"context"
	"log"
	"time"

	"github.com/orcaman/concurrent-map"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"

	"github.com/notyim/gaia/db"
)

type OperationType int

const (
	Insert OperationType = iota
	Replace
	Delete
)

func (o OperationType) FromString(s string) OperationType {
	return map[string]OperationType{
		"insert":  Insert,
		"replace": Replace,
		"delete":  Delete,
	}[s]
}

type Repo struct {
	client *mongo.Client
	dbName string
}

type Check struct {
	ID        primitive.ObjectID `bson:"_id"`
	Name      string             `bson:"name"`
	Type      string             `bson:"type"`
	URI       string             `bson:"uri"`
	CreatedAt time.Time          `bson:"created_at"`
	UpdatedAt time.Time          `bson:"updated_at"`
}

func (c *Check) IsHttp() bool {
	return c.Type == "http"
}

func (c *Check) IsTCP() bool {
	log.Println(c.ID.Hex(), "has type", c.Type)
	return c.Type == "tcp"
}

func (c *Check) IsBeat() bool {
	return c.Type == "heartbeat"
}

func New(dbClient *db.Client, dbName string) *Repo {
	return &Repo{
		client: dbClient.Client,
		dbName: dbName,
	}
}

func (r *Repo) GetChecks() (*cmap.ConcurrentMap, error) {
	checks := cmap.New()

	collection := r.client.Database(r.dbName).Collection("checks")
	cur, err := collection.Find(context.Background(), bson.D{})

	if err != nil {
		log.Fatal(err)
	}

	defer cur.Close(context.Background())

	for cur.Next(context.Background()) {
		var result Check
		err := cur.Decode(&result)
		if err != nil {
			log.Fatal(err)
		}

		checks.Set(result.ID.Hex(), &result)
	}

	if err := cur.Err(); err != nil {
		return nil, err
	}

	return &checks, nil
}

func RecordCheckResult() {

}

type CheckListener func(OperationType, *Check)

func (r *Repo) ListenToChecks(subscribe CheckListener) {
	collection := r.client.Database(r.dbName).Collection("checks")
	ctx := context.Background()

	cs, err := collection.Watch(ctx, mongo.Pipeline{}, options.ChangeStream().SetFullDocument(options.UpdateLookup))
	if err != nil {
		log.Fatal("Cannot watch change", err)
	}

	defer cs.Close(ctx)

	for {
		ok := cs.Next(ctx)
		if ok {
			change := struct {
				FullDocument Check `bson:"fullDocument"`
				DocumentKey  struct {
					ID primitive.ObjectID `bson:"_id"`
				} `bson:"documentKey"`
				OperationType string `bson:"operationType"`
			}{}
			log.Println(cs.Current)

			cs.Decode(&change)
			log.Printf("Get change %v\n", change)
			if err != nil {
				log.Fatal("Fail 2 decode", err)
			}

			var o OperationType
			subscribe(o.FromString(change.OperationType), &change.FullDocument)
		}
	}
}
