package controllers

import (
	"net/http"
	"strings"

	"prm/com.omnicon.prm.service/log"
)

func PostData(pOperation string, pRequest *strings.Reader) (*http.Response, error) {

	if pRequest == nil {
		pRequest = strings.NewReader("{\n\n}")
	}
	req, _ := http.NewRequest("POST", getURL(pOperation), pRequest)
	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Error(err.Error())
	}

	return res, err
}
func getURL(pOperation string) string {
	postUrl := URL + pOperation
	return postUrl
}
