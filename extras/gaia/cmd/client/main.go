package main

import (
	"github.com/notyim/gaia/client"
)

func main() {
	agent := client.New()

	agent.Run()
}
