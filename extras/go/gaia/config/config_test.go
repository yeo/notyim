package config

import (
	"testing"
)

func TestNewConfig(t *testing.T) {
	c := NewConfig()
	if c.DbHost != "127.0.0.1" {
		t.Fatalf("Bad default DbHost value: %v", c.DbHost)
	}
}
