package gaia

import (
	"fmt"
	"log"
	"sync"

	"github.com/gorilla/websocket"
	"github.com/orcaman/concurrent-map"

	"github.com/notyim/gaia/dao"
)

// Syncer maintenances state between server and agent. Whenever checks are updated, sync replicate the state to agent
type Syncer struct {
	Checks *cmap.ConcurrentMap
	Agents *sync.Map
}

func (s *Syncer) AddAgent(name string, conn *websocket.Conn) {
	log.Println("Agent connected", name)
	s.Agents.Store(name, conn)
}

func (s *Syncer) DeleteAgent(name string) {
	log.Println("Agent disconnected", name)
	s.Agents.Delete(name)
	log.Println("Log Connected agent")
	s.Agents.Range(func(name, conn interface{}) bool {
		log.Println(" * ", name)
		return true
	})
}

func (s *Syncer) LoadAllChecks(repo *dao.Repo) error {
	var err error
	s.Checks, err = repo.GetChecks()
	if err != nil {
		return fmt.Errorf("Cannot load check from mongodb %w", err)
	}
	fmt.Println("Loaded", s.Checks.Count(), "checks")

	return nil
}

func (s *Syncer) DbListener(t dao.OperationType, c *dao.Check) {
	log.Println("Receive check changeset from database", c)
	// Handle update/delete/create checks
	// First, update our state
	switch t {
	case dao.Insert:
		s.Checks.Set(c.ID.Hex(), c)
		s.PushMessages([]byte(c.ID.Hex()))
	case dao.Delete:
		s.Checks.Remove(c.ID.Hex())
		s.PushMessages([]byte("delete"))
	case dao.Replace:
		s.PushMessages([]byte("update"))
	}
}

func (s *Syncer) PushMessages(m []byte) {
	// Second, notify gaia client
	s.Agents.Range(func(name, conn interface{}) bool {
		conn.(*websocket.Conn).WriteMessage(websocket.TextMessage, m)
		return true
	})
}

func (s *Syncer) PushChecksToAgent(name string) {
	conn, _ := s.Agents.Load(name)

	for _, check := range s.Checks.Items() {
		conn.(*websocket.Conn).WriteMessage(websocket.TextMessage, []byte(check.(*dao.Check).ID.Hex()))
	}
}
