package server

import (
	"github.com/jrallison/go-workers"
)

// Configure Worker
func CreateWorker(server, database, pool string) {
	workers.Configure(map[string]string{
		// location of redis instance
		"server": server,
		// instance of the database
		"database": database,
		// number of connections to keep open with redis
		"pool": pool,
		// unique process id for this instance of workers (for proper recovery of inprogress jobs on crash)
		"process": "1",
	})
	go workers.StatsServer(28305)
}
