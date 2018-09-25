package noty

import (
	"bytes"
	"fmt"
	//"io/ioutil"
	"log"
	"net/http"
)

type Api struct {
	baseUrl string
	token   string
	client  *http.Client
}

type Request struct {
	Method   string
	Endpoint string
	Body     []byte //json body
	Queries  map[string]string
	Headers  map[string]string
}

type Response struct {
}

func NewApi(url string, token string) *Api {
	api := Api{
		baseUrl: url,
		token:   token,
		client:  &http.Client{},
	}
	return &api
}

func (a *Api) Request(r *Request) error {
	var req *http.Request
	var err error

	switch r.Method {
	case "POST":
		//req, err = http.NewRequest("POST", fmt.Sprintf("%s/%s?noty_token=", a.baseUrl, r.Endpoint), bytes.NewBufferString(r.Body))
		//@TODO make this http type flexible
		req, err = http.NewRequest("POST", fmt.Sprintf("%s/%s/http?noty_token=", a.baseUrl, r.Endpoint), bytes.NewBuffer(r.Body))
		if err != nil {
			log.Printf("Cannot create request %v", err)
			return nil
		}
	}

	req.Header.Set("X-NOTY-TOKEN", a.token)
	req.Header.Set("Content-Type", "application/json")

	resp, err := a.client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	return nil

	//fmt.Println("response Status:", resp.Status)
	//fmt.Println("response Headers:", resp.Header)
	//body, _ := ioutil.ReadAll(resp.Body)
	//fmt.Println("response Body:", string(body))
}
