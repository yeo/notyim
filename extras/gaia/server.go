package gaia

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/unrolled/secure"

	"github.com/notyim/gaia/dao"
	"github.com/notyim/gaia/db"
	"github.com/notyim/gaia/errorlog"
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
	secureMiddleware := secure.New(secure.Options{
		AllowedHosts:         []string{"noty.ax", "gaia.noty.im", "laputa.noty.im", ".*.noty.im"},
		AllowedHostsAreRegex: true,
		HostsProxyHeaders:    []string{"X-Forwarded-Host"},
		FrameDeny:            true,
		ReferrerPolicy:       "same-origin",
		IsDevelopment:        s.Config.IsDev(),
	})

	s.Echo.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, Version("Server")+"\nInstall server with.\ncurl -s https://gaia.noty.im/install | bash")
	})

	s.Echo.GET("/agents", func(c echo.Context) error {
		return c.JSON(http.StatusOK, s.Syncer.ListAgents())
	})

	s.Echo.GET("/checks", func(c echo.Context) error {
		return c.JSON(http.StatusOK, s.Syncer.Checks)
	})

	s.Echo.POST("/beat/:id", handleBeat(s.Sink.Pipe))
	s.Echo.POST("/beat/:id/:action", handleBeat(s.Sink.Pipe))

	var upgrader = websocket.Upgrader{}

	s.Echo.GET("/ws/:name", func(c echo.Context) error {
		name := c.Param("name")
		region := c.QueryParam("region")
		version := c.QueryParam("version")
		ip := c.RealIP()

		conn, err := upgrader.Upgrade(c.Response(), c.Request(), nil)
		if err != nil {
			log.Println(err)
			return err
		}

		// Store this connection into our agent list
		s.Syncer.AddAgent(name, &AgentConnection{Conn: conn, IP: ip, Version: version, Region: region, Stats: &AgentActivity{}})

		defer func() {
			// When we close we will make sure we delete the agent first
			s.Syncer.DeleteAgent(name)
			conn.Close()
		}()

		// At this point, connection is succesful. We will started to copy checks
		go s.Syncer.PushChecksToAgent(name)

		if err = s.Syncer.ListenFromAgent(name, s.Sink); err != nil {
			// Should we close this?
			errorlog.Capture(err)
			log.Println("Error read from client", err)
			return err
		}

		return nil
	})

	errorlog.WrapMiddleware(s.Echo)
	s.Echo.Use(echo.WrapMiddleware(secureMiddleware.Handler))
	s.Echo.Use(middleware.Logger())
	s.Echo.Use(middleware.Recover())
	s.Echo.Use(s.Auth)
}

func (s *Server) Auth(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		key := c.QueryParam("apikey")
		if key == "" {
			key = c.Request().Header.Get("apikey")
		}

		if key == s.Config.ApiKey {
			return next(c)
		} else {
			return echo.ErrUnauthorized
		}
	}
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
	SetupErrorLog()

	fmt.Println("Personification of the Earth")

	config := LoadConfig()

	server := &Server{
		Config:    config,
		Echo:      echo.New(),
		DBClient:  db.Connect(config.MongoURI),
		Syncer:    NewSyncer(),
		Scheduler: NewScheduler(),
		Sink:      NewSink(config.Sink(), config.Redis()),
	}

	server.SetupSink()
	server.SetupRoute()
	server.SetupChecker()
	server.SetupSchedule()
	return server
}

func SetupErrorLog() {
	errorlog.Hook()
}
