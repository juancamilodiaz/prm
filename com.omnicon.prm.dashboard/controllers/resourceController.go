package controllers

import (
	"encoding/json"
	"fmt"
	//	"io/ioutil"
	"net/http"
	//"os"
	"strings"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type ResourceController struct {
	beego.Controller
}

var URL string = "http://localhost:10104/"

/*Index*/
func (this *ResourceController) Get() {
	this.Data["Website"] = "beego.me"
	this.Data["Email"] = "astaxie@gmail.com"
	this.TplName = "index.tpl"
	//TODO quitar website....
}

/* Resources */
func (this *ResourceController) ListResources() {
	operation := "GetResources"

	res, err := PostData(operation, nil)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("Resources", message.Resources)
		this.Data["Resources"] = message.Resources
		this.TplName = "Resources/listResources.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func (this *ResourceController) CreateResource() {
	operation := "CreateResource"

	payload := strings.NewReader("{" +
		"\n\t\"Name\":\"" + this.GetString("Name") + "\"," +
		"\n\t\"LastName\":\"" + this.GetString("LastName") + "\"," +
		"\n\t\"Email\":\"" + this.GetString("Email") + "\"," +
		"\n\t\"Photo\":\"" + this.GetString("Photo") + "\"," +
		"\n\t\"EngineerRange\":\"" + this.GetString("EngineerRange") + "\"," +
		"\n\t\"Enabled\":" + this.GetString("Enabled") +
		"\n}")
	fmt.Println(payload)

	res, _ := PostData(operation, payload)

	message := new(domain.GetResourcesRS)
	json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)

	defer res.Body.Close()
}

func (main *ResourceController) ReadResource() {
	operation := "GetResources"

	payload := strings.NewReader("{\n\t\"Id\":" + main.Ctx.Input.Param(":id") + "\n}")

	res, err := PostData(operation, payload)

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

func (main *ResourceController) UpdateResource() {
	operation := "UpdateResource"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + main.GetString("ID") + "," +
		"\n\t\"Name\":\"" + main.GetString("Name") + "\"," +
		"\n\t\"LastName\":\"" + main.GetString("LastName") + "\"," +
		"\n\t\"Email\":\"" + main.GetString("Email") + "\"," +
		"\n\t\"Photo\":\"" + main.GetString("Photo") + "\"," +
		"\n\t\"EngineerRange\":\"" + main.GetString("EngineerRange") + "\"," +
		"\n\t\"Enabled\":" + main.GetString("Enabled") + "\n}")

	fmt.Println(payload)

	res, err := PostData(operation, payload)

	message := new(domain.UpdateResourceRS)
	json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	log.Error(err.Error())
}

func (main *ResourceController) DeleteResource() {
	operation := "DeleteResource"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + main.GetString("ID") +
		"\n}")
	fmt.Println(payload)
	req, _ := http.NewRequest("POST", operation, payload)

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
