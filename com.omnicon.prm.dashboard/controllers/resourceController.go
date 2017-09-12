package controllers

import (
	"encoding/json"
	"fmt"

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

	input := domain.CreateResourceRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	fmt.Printf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.CreateResourceRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	if err != nil {
		log.Error(err.Error())
	}

	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
	this.TplName = "Common/message.tpl"
}

func (this *ResourceController) ReadResource() {
	operation := "GetResources"

	input := domain.GetResourcesRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	fmt.Printf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		fmt.Println("Respuesta", res)
		defer res.Body.Close()
		message := new(domain.GetResourcesRS)
		json.NewDecoder(res.Body).Decode(&message)

		this.Data["Resources"] = message.Resources
		this.TplName = "Resources/viewResources.tpl"
	} else {
		log.Error(err.Error())
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (this *ResourceController) UpdateResource() {
	operation := "UpdateResource"

	input := domain.UpdateResourceRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	fmt.Printf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.UpdateResourceRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
	this.TplName = "Common/message.tpl"
}

func (this *ResourceController) DeleteResource() {
	operation := "DeleteResource"

	input := domain.DeleteResourceRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	fmt.Printf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.DeleteResourceRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
	this.TplName = "Common/message.tpl"
}

func (this *ResourceController) GetSkillsByResource() {
	operation := "GetSkillsByResource"

	input := domain.GetSkillByResourceRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	fmt.Printf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetSkillByResourceRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("GetSkillsByResource", message.Skills)
		this.Data["ResourceId"] = input.ID
		this.Data["Skills"] = message.Skills
		this.Data["Title"] = this.GetString("ResourceName")
		this.TplName = "Resources/listSkillsByResource.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func (this *ResourceController) SetSkillsToResource() {
	operation := "SetSkillToResource"

	input := domain.SetSkillToResourceRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	fmt.Printf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.SetSkillToResourceRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("SetSkillsByResource", message.Resource)
		this.Data["Skills"] = message.Resource.Skills
		this.Data["Title"] = this.GetString("ResourceName")
		this.TplName = "Resources/listSkillsByResource.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func (this *ResourceController) DeleteSkillsToResource() {
	operation := "DeleteSkillToResource"

	input := domain.DeleteSkillToResourceRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	fmt.Printf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	defer res.Body.Close()
	message := new(domain.DeleteSkillToResourceRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	if err == nil {
		fmt.Println("DeleteSkillToResource", message.SkillName, message.ResourceName)
		this.Data["SkillName"] = message.SkillName
		this.Data["ResourceName"] = message.ResourceName
		this.Data["Title"] = this.GetString("ResourceName")
	} else {
		log.Error(err.Error())
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
	}
	this.TplName = "Common/message.tpl"
}
