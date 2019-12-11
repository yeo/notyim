package me

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"time"
)

type IPinfo struct {
	IP       string `json:"ip"`
	Hostname string `json:"hostname"`
	City     string `json:"city"`
	Region   string `json:"region"`
	Country  string `json:"country"`
	Timezone string `json:"timezone"`
}

func Fetch() (*IPinfo, error) {
	var netClient = &http.Client{
		Timeout: time.Second * 10,
	}
	response, err := netClient.Get("https://ipinfo.io/json")

	if response != nil {
		defer response.Body.Close()
	}
	var ipinfo IPinfo
	body, err := ioutil.ReadAll(response.Body)

	err = json.Unmarshal(body, &ipinfo)

	return &ipinfo, err

}
