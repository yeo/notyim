package errorlog

import (
	"log"
	"os"
	"time"

	"github.com/getsentry/sentry-go"

	sentryecho "github.com/getsentry/sentry-go/echo"
	"github.com/labstack/echo/v4"
)

func Hook() {
	sentryDSN := os.Getenv("SENTRY_DSN")
	err := sentry.Init(sentry.ClientOptions{
		Dsn: sentryDSN,
	})
	if err != nil {
		log.Fatal("Cannot initialize errorlog with Sentry")
	}
}

func WrapMiddleware(e *echo.Echo) {
	e.Use(sentryecho.New(sentryecho.Options{
		Repanic:         true,
		WaitForDelivery: false,
		Timeout:         10 * time.Second,
	}))
}

func Flush() {
	sentry.Flush(time.Second * 5)
}

func Capture(e error) {
	sentry.CaptureException(e)
}
