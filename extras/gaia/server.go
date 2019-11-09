package gaia

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo"
	"github.com/orcaman/concurrent-map"

	"github.com/notyim/gaia/dao"
	"github.com/notyim/gaia/db"
)

// Server is main struct that hold gaia server component
type Server struct {
	Config *Config
	*echo.Echo
	DBClient *db.Client
	Checks   *cmap.ConcurrentMap
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
		return c.JSON(http.StatusOK, s.Checks)
	})
}

// SetupChecker starts checker process
func (s *Server) SetupChecker() {
	repo := dao.New(s.DBClient, s.Config.MongoDBName)

	var subscribe = func(c *dao.Check) {
		fmt.Println("Hook up", c)
		s.Checks.Set(c.ID.Hex(), c)
	}
	go repo.ListenToChecks(subscribe)

	fmt.Println("Starting checker")

	s.Checks, _ = repo.GetChecks()
	fmt.Println("Loaded", s.Checks.Count(), "checks")
}

// Run officially starts our server
func (s *Server) Run() {
	s.Echo.Logger.Fatal(s.Echo.Start(":28300"))
}

// InitServer is main entrypoint into system
// Thing start from here. It glues components
func InitServer() {
	fmt.Println("Personification of the Earth")

	e := echo.New()

	config := LoadConfig()

	server := &Server{
		Echo:     e,
		Config:   config,
		DBClient: db.Connect(config.MongoURI),
	}

	server.SetupRoute()
	server.SetupChecker()
	server.Run()
}
