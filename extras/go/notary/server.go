package main

import (
	"io/ioutil"
	"net/http"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	e := echo.New()
	e.Use(middleware.Logger())

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, World!")
	})

	e.POST("/post", func(c echo.Context) error {
		// Request
		reqBody := []byte{}
		if c.Request().Body != nil { // Read
			reqBody, _ = ioutil.ReadAll(c.Request().Body)
		}

		return c.String(http.StatusOK, string(reqBody))
	})

	e.Logger.Fatal(e.Start(":1323"))
}
