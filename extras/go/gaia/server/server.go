package server

import (
	"log"

	"github.com/notyim/gaia/config"
)

// Initialize gaia server
func Start(c *config.Config) {
	log.Println("Initalize server and bind to", c.GaiaServerBindTo)
}
