package gaia

import (
	"fmt"
	"log"
	"net/http"
	"sync"

	"github.com/gorilla/websocket"
	"github.com/labstack/echo"
	"github.com/orcaman/concurrent-map"

	"github.com/notyim/gaia/dao"
	"github.com/notyim/gaia/db"
)

// Server is main struct that hold gaia server component
type Server struct {
	*echo.Echo
	Config    *Config
	DBClient  *db.Client
	Syncer    *Syncer
	Scheduler *Scheduler
	// TODO: Refactor queue into interface
	Sink *Sink
}

// SetupRoute configures router layer
func (s *Server) SetupRoute() {
	s.Echo.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Gaia Ok.\nInstall server with.\ncurl -s https://gaia.noty.im/install | bash")
	})

	s.Echo.POST("/join", func(c echo.Context) error {
		return c.String(http.StatusOK, "Join request received.")
	})

	s.Echo.GET("/checks", func(c echo.Context) error {
		return c.JSON(http.StatusOK, s.Syncer.Checks)
	})

	var upgrader = websocket.Upgrader{}

	s.Echo.GET("/ws/:name", func(c echo.Context) error {
		name := c.Param("name")

		conn, err := upgrader.Upgrade(c.Response(), c.Request(), nil)
		if err != nil {
			return err
		}

		// Store this connection into our agent list
		s.Syncer.AddAgent(name, conn)

		defer func() {
			// When we close we will make sure we delete the agent first
			s.Syncer.DeleteAgent(name)
			conn.Close()
		}()

		// At this point, connection is succesful. We will started to copy checks
		go s.Syncer.PushChecksToAgent(name)

		// Keep listening for messge from client like Check Result push
		for {
			_, message, err := conn.ReadMessage()
			if err != nil {
				return err
			}

			var evt GenericEvent
			if err = evt.UnmarshalJSON(message); err != nil {
				log.Println("Cannot unmarshalJSON")
				continue
			}

			switch evt.EventType {
			case EventTypePing:
				log.Printf("Agent %s ping", name)
			case EventTypeCheckHTTPResult:
				log.Printf("Agent check result %s %d", evt.EventCheckHTTPResult.ID, evt.EventCheckHTTPResult.Result)
				s.Sink.Pipe <- evt.EventCheckHTTPResult
			}
		}
	})
}

// SetupChecker starts checker process
func (s *Server) SetupChecker() {
	fmt.Println("Setup Checker")
	repo := dao.New(s.DBClient, s.Config.MongoDBName)

	fmt.Println("Register mongodb changestream subscriber")
	go repo.ListenToChecks(s.Syncer.DbListener)

	fmt.Println("Building checks database")
	s.Syncer.LoadAllChecks(repo)
}

func (s *Server) SetupSchedule() {
	go s.Scheduler.Run(s.Syncer)
}

func (s *Server) SetupSink() {
	go s.Sink.Run()
}

// Run officially starts our server
func (s *Server) Run() {
	s.Echo.Logger.Fatal(s.Echo.Start(":28300"))
}

// InitServer is main entrypoint into system
// Thing start from here. It glues components
func InitServer() *Server {
	fmt.Println("Personification of the Earth")

	config := LoadConfig()
	checks := cmap.New()
	syncer := &Syncer{
		Agents: &sync.Map{},
		Checks: &checks,
	}

	server := &Server{
		Config:    config,
		Echo:      echo.New(),
		DBClient:  db.Connect(config.MongoURI),
		Syncer:    syncer,
		Scheduler: NewScheduler(),
		Sink:      NewSink(config.Sink(), config.Redis()),
	}

	server.SetupSink()
	server.SetupRoute()
	server.SetupChecker()
	server.SetupSchedule()
	return server
}
