package gaia

import (
	"time"

	"github.com/labstack/echo/v4"
)

func handleBeat(ch chan CheckPipeable) func(echo.Context) error {
	return func(c echo.Context) error {
		beatEvent := EventCheckBeat{
			EventType: EventTypeBeat,
			ID:        c.Param("id"),
			Action:    "",
			BeatAt:    time.Now(),
		}

		if action := c.Param("action"); action != "" {
			beatEvent.Action = action
		}

		ch <- &beatEvent
		return nil
	}
}
