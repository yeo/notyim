package watcher

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	//"net/url"
	"github.com/notyim/gaia/monitor/core"
	"github.com/notyim/gaia/watcher"
	"sync"
	"testing"
)

func Test_ResponseChangesWillCallApi(t *testing.T) {
	w := watcher.NewWatcher
}
