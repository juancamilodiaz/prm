package util

import (
	"bytes"
	"encoding/json"
	"net/http"
)

var URL string = "http://localhost:10104/"

func PostData(pOperation string, pRequest *bytes.Buffer) (*http.Response, error) {

	if pRequest == nil {
		pRequest = bytes.NewBuffer([]byte("{\n\n}"))
	}
	req, _ := http.NewRequest("POST", getURL(pOperation), pRequest)
	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		//log.Error(err.Error())
	}

	return res, err
}

func getURL(pOperation string) string {
	postUrl := URL + pOperation
	return postUrl
}

func EncoderInput(pInput interface{}) *bytes.Buffer {

	bufferInput := new(bytes.Buffer)
	json.NewEncoder(bufferInput).Encode(pInput)

	return bufferInput
}
