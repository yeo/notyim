package watcher

import (
	//"fmt"
	"encoding/json"
	r "github.com/dancannon/gorethink"
	"github.com/notyim/gaia/env"
	"github.com/notyim/gaia/noty"
	//	"github.com/notyim/gaia/types"
	"log"
)

type Watcher struct {
	env    *env.Env
	cursor *r.Cursor
}

var (
	api *noty.Api
)

func NewWatcher(e *env.Env) *Watcher {
	w := Watcher{e, nil}
	api = noty.NewApi(e.Config.AppHost, e.Config.AppApiToken)
	return &w
}

// Stop terminate watching
func (w *Watcher) Stop() {
	log.Println("Watcher: Stop watching RethinkDB")
	w.cursor.Close()
}

func (w *Watcher) Run() {
	log.Println("Watcher: Start watching RethinkDB")

	// Watcher for event change in our table and notify app
	res, err := r.Table("http_response").Changes().
		Run(w.env.Rethink)
	w.cursor = res

	if err != nil {
		log.Fatal("error when listent o change on RethinkDB %v", err)
	}
	//defer res.Close()

	//var response struct {
	//	old_val types.RethinkService
	//	new_val types.RethinkService
	//}
	//var response map[string]types.RethinkService
	var _response interface{}

	for res.Next(&_response) {
		response := _response.(map[string]interface{})

		payload := map[string]interface{}{
			"old": response["old_val"],
			"new": response["new_val"],
		}
		jsonPayload, err := json.Marshal(payload)
		if err != nil {
			log.Printf("Cannot encode JSON %v", err)
			return
		}
		r := noty.NewStatus(jsonPayload)
		api.Request(r)
	}
}
