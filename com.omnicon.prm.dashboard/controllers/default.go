package controllers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type MainController struct {
	beego.Controller
}

/*Index*/
func (c *MainController) Get() {
	c.Data["Website"] = "beego.me"
	c.Data["Email"] = "astaxie@gmail.com"
	c.TplName = "index.tpl"
}

/* Resources */
func (main *MainController) ListResources() {
	url := "http://172.16.33.81:10104/GetResources"

	payload := strings.NewReader("{\n\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("Resources", message.Resources)
		main.Data["Resources"] = message.Resources
		main.TplName = "Resources/listResources.tpl"
	} else {
		main.Data["Title"] = "The Service is down."
		main.Data["Message"] = "Please contact with the system manager."
		main.Data["Type"] = "Error"
		main.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (main *MainController) CreateResource() {
	url := "http://172.16.33.81:10104/CreateResource"

	payload := strings.NewReader("{" +
		"\n\t\"Name\":\"" + main.GetString("Name") + "\"," +
		"\n\t\"LastName\":\"" + main.GetString("LastName") + "\"," +
		"\n\t\"Email\":\"" + main.GetString("Email") + "\"," +
		"\n\t\"Photo\":\"" + main.GetString("Photo") + "\"," +
		"\n\t\"EngineerRange\":\"" + main.GetString("EngineerRange") + "\"," +
		"\n\t\"Enabled\":" + main.GetString("Enabled") +
		"\n}")
	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)

	message := new(domain.GetResourcesRS)
	json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	log.Error(err.Error())
}

func (main *MainController) ReadResource() {
	url := "http://172.16.33.81:10104/GetResources"

	payload := strings.NewReader("{\n\t\"Id\":" + main.Ctx.Input.Param(":id") + "\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")
	req.Header.Add("postman-token", "4912b41c-8142-84c6-61b3-a6d2d8d3daec")

	res, err := http.DefaultClient.Do(req)

	if err == nil {
		fmt.Println("Respuesta", res)
		defer res.Body.Close()
		message := new(domain.GetResourcesRS)
		json.NewDecoder(res.Body).Decode(&message)

		main.Data["Resources"] = message.Resources
		main.TplName = "Resources/viewResources.tpl"
	} else {
		log.Error(err.Error())
		main.Data["Title"] = "The Service is down."
		main.Data["Message"] = "Please contact with the system manager."
		main.Data["Type"] = "Error"
		main.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (main *MainController) UpdateResource() {
	url := "http://172.16.33.81:10104/CreateResource"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":\"" + main.Ctx.Input.Param(":ID") + "\"," +
		"\n\t\"Name\":\"" + main.Ctx.Input.Param(":Name") + "\"," +
		"\n\t\"LastName\":\"" + main.Ctx.Input.Param(":LastName") + "\"," +
		"\n\t\"Email\":\"" + main.Ctx.Input.Param(":Email") + "\"," +
		"\n\t\"Photo\":\"" + main.Ctx.Input.Param(":Photo") + "\"," +
		"\n\t\"EngineerRange\":\"" + main.Ctx.Input.Param(":EngineerRange") + "\"," +
		"\n\t\"Enabled\":" + main.Ctx.Input.Param(":Enabled") + "\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")
	req.Header.Add("postman-token", "4c022020-525b-e96b-a4c8-9b72d14476b1")

	res, err := http.DefaultClient.Do(req)

	defer res.Body.Close()
	log.Error(err.Error())
}

func (main *MainController) DeleteResource() {
	url := "http://172.16.33.81:10104/DeleteResource"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + main.GetString("ID") +
		"\n}")
	fmt.Println(payload)
	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("accept", "application/json")
	req.Header.Add("content-type", "application/json")
	req.Header.Add("cache-control", "no-cache")

	res, err := http.DefaultClient.Do(req)

	message := new(domain.GetResourcesRS)
	json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	log.Error(err.Error())
}
