package cmd

import (
	"github.com/notyim/gaia/agent"
	"github.com/notyim/gaia/config"
	"github.com/spf13/cobra"
)

// monitorCmd respresents the monitor command
var clientCmd = &cobra.Command{
	Use:   "client",
	Short: "Gaia client Mode",
	Long:  `Client fetch checks, execute and push result back`,
	Run: func(cmd *cobra.Command, args []string) {
		config := config.NewConfig()
		client := agent.NewClient(config)
		client.Start()
	},
}

func init() {
	rootCmd.AddCommand(clientCmd)
}
