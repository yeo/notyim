package gaia

import (
	"fmt"
)

var (
	AppVersion    string
	BuildRevision string
	BuildDate     string
)

func Version(prefix string) string {
	return fmt.Sprintf("Gaia %s %s %s %s", prefix, AppVersion, BuildRevision, BuildDate)
}
