package cmd

import (
	"github.com/notyim/gaia/config"
	"github.com/notyim/gaia/server"
	"github.com/spf13/cobra"
)

// monitorCmd respresents the monitor command
var serverCmd = &cobra.Command{
	Use:   "server",
	Short: "Gaia Server Mode",
	Long:  `Run Gaia Server that command the client to run check and update result to our storage`,
	Run: func(cmd *cobra.Command, args []string) {
		config := config.NewConfig()
		server.Start(config)
	},
}

func init() {
	rootCmd.AddCommand(serverCmd)
}
