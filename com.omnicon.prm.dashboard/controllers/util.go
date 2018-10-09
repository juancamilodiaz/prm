package controllers

import (
	"bytes"
	"encoding/json"
	"net/http"
	"strings"

	"prm/com.omnicon.prm.service/log"
)

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
		log.Error(err.Error())
	}

	return res, err
}

func PostDataProxy(pOperation string, pRequest *bytes.Buffer) (*http.Response, error) {

	if pRequest == nil {
		pRequest = bytes.NewBuffer([]byte("{\n\n}"))
	}
	req, _ := http.NewRequest("POST", getURLProxy(pOperation), pRequest)
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

func getURLProxy(pOperation string) string {
	postUrl := URLProxy + pOperation
	return postUrl
}

func EncoderInput(pInput interface{}) *bytes.Buffer {

	bufferInput := new(bytes.Buffer)
	json.NewEncoder(bufferInput).Encode(pInput)

	return bufferInput
}

func TruncateString(str string, num int) string {
	bnoden := str
	if len(str) > num {
		if num > 3 {
			num -= 3
		}
		bnoden = str[0:num]
	}
	return bnoden
}

func BuildURI(pHttps bool, pHost, pPort string, pPaths ...string) string {
	var uri bytes.Buffer
	if pHttps {
		uri.WriteString("https://")
	} else {
		uri.WriteString("http://")
	}

	if pHost != "" {
		uri.WriteString(pHost)
	}
	if pPort != "" {
		uri.WriteString(":")
		uri.WriteString(pPort)
	}
	for _, path := range pPaths {
		uri.WriteString("/")
		uri.WriteString(path)
	}
	return uri.String()
}

func authorizeLevel(pEmail, pSuperUsers, pAdminUsers, pPlanUsers, pTrainerUsers string) int {

	for _, email := range strings.Split(pSuperUsers, ";") {
		if strings.EqualFold(email, pEmail) {
			return su
		}
	}

	for _, email := range strings.Split(pAdminUsers, ";") {
		if strings.EqualFold(email, pEmail) {
			return au
		}
	}

	for _, email := range strings.Split(pPlanUsers, ";") {
		if strings.EqualFold(email, pEmail) {
			return pu
		}
	}

	for _, email := range strings.Split(pTrainerUsers, ";") {
		if strings.EqualFold(email, pEmail) {
			return tu
		}
	}

	return du

}
