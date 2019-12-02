package gaia

import (
	"encoding/json"
	"fmt"
	"log"
	"sync"
	"time"

	"github.com/gorilla/websocket"
	"github.com/orcaman/concurrent-map"

	"github.com/notyim/gaia/dao"
)

type ScheduleChecks interface {
	ScheduleChecks()
}

// Track last time gaia talk to client
// Track last time client ping gaia
// Track last time client send check result

type AgentActivity struct {
	LastMessageFromServer time.Time
	LastResultSent        time.Time
}

// Syncer maintenances state between server and agent. Whenever checks are updated, sync replicate the state to agent
type Syncer struct {
	Checks     *cmap.ConcurrentMap
	Agents     *sync.Map
	TotalAgent int
	activity   *sync.Map
}

func (s *Syncer) ListAgents() []string {
	var agents []string
	s.Agents.Range(func(name, conn interface{}) bool {
		agents = append(agents, name.(string))

		return true
	})

	return agents
}

func (s *Syncer) AddAgent(name string, conn *websocket.Conn) {
	log.Println("Agent connected", name)
	s.Agents.Store(name, conn)
	s.TotalAgent += 1
	log.Println("Connected agent: ", s.TotalAgent)
}

func (s *Syncer) DeleteAgent(name string) {
	log.Println("Agent disconnected", name)
	s.Agents.Delete(name)
	s.TotalAgent -= 1
	log.Println("Connected agent: ", s.TotalAgent)
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
	switch t {
	case dao.Insert:
		s.Checks.Set(c.ID.Hex(), c)

		evt := EventCheckInsert{
			EventType: EventTypeCheckInsert,
			Check:     c,
		}

		if payload, err := json.Marshal(evt); err == nil {
			s.PushMessages(payload)
		}
	case dao.Delete:
		s.Checks.Remove(c.ID.Hex())

		evt := EventCheckDelete{
			EventType: EventTypeCheckDelete,
			Check:     c,
		}

		if payload, err := json.Marshal(evt); err == nil {
			s.PushMessages(payload)
		}
	case dao.Replace:
		evt := EventCheckReplace{
			EventType: EventTypeCheckReplace,
			Check:     c,
		}

		if payload, err := json.Marshal(evt); err == nil {
			s.PushMessages(payload)
		}
	}
}

func (s *Syncer) PushMessages(m []byte) {
	// Second, notify gaia client
	s.Agents.Range(func(name, conn interface{}) bool {
		conn.(*websocket.Conn).WriteMessage(websocket.TextMessage, m)
		return true
	})
}

func (s *Syncer) PushMessageToAgent(agentName string, payload []byte) {
	conn, _ := s.Agents.Load(agentName)
	conn.(*websocket.Conn).WriteMessage(websocket.TextMessage, payload)
}

func (s *Syncer) PushChecksToAgent(name string) {
	log.Println("About to push checks to agent", name)
	conn, _ := s.Agents.Load(name)

	total := 0
	for _, check := range s.Checks.Items() {

		evt := EventCheckInsert{
			EventType: EventTypeCheckInsert,
			Check:     check.(*dao.Check),
		}

		if payload, err := json.Marshal(evt); err == nil {
			conn.(*websocket.Conn).WriteMessage(websocket.TextMessage, payload)
		}
		total += 1
	}
	log.Println("Pushed checks to agent", name, total)
}

func (s *Syncer) ScheduleChecks() {
	s.Agents.Range(func(name, conn interface{}) bool {
		agent := name.(string)

		to := time.Now()
		i := 0
		for _, check := range s.Checks.Items() {
			i++
			command := EventRunCheck{
				EventType: EventTypeRunCheck,
				ID:        check.(*dao.Check).ID.Hex(),
			}

			if payload, err := json.Marshal(command); err == nil {
				s.PushMessageToAgent(agent, payload)
			}
		}
		log.Printf("Push %d messages in %v\n", i, time.Now().Sub(to))

		return true
	})
}
