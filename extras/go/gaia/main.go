package main

import (
	"log"

	//"github.com/notyim/gaia/types"
	"github.com/notyim/gaia/cmd"
)

// Version of gaia, inject from build w/
//    -ldflags "-X main.Version=`git describe --always --tags`"
var Version string

func main() {
	log.Printf("Starting Gaia (version %s)\n", Version)
	cmd.Execute()
}
