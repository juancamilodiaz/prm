package controllers

import (
	"encoding/json"
	"fmt"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type ProjectController struct {
	beego.Controller
}

/* Projects */
func (this *ProjectController) ListProjects() {
	operation := "GetProjects"

	res, err := PostData(operation, nil)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("Projects", message.Projects)
		this.Data["Projects"] = message.Projects
		this.TplName = "Projects/listProjects.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (this *ProjectController) CreateProject() {

	operation := "CreateProject"

	input := domain.CreateProjectRQ{}
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

	defer res.Body.Close()
	message := new(domain.CreateProjectRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	if err != nil {
		log.Error(err.Error())
	}
	this.TplName = "Common/message.tpl"
}

func (this *ProjectController) ReadProject() {
	operation := "GetProjects"

	input := domain.GetProjectsRQ{}
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
		message := new(domain.GetProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)

		this.Data["Projects"] = message.Projects
		this.TplName = "Projects/viewProjects.tpl"
	} else {
		log.Error(err.Error())
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (this *ProjectController) UpdateProject() {
	operation := "UpdateProject"

	input := domain.UpdateProjectRQ{}
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

	defer res.Body.Close()
	message := new(domain.UpdateProjectRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	if err != nil {
		log.Error(err.Error())
	}
	this.TplName = "Common/message.tpl"
}

func (this *ProjectController) DeleteProject() {
	operation := "DeleteProject"

	input := domain.DeleteProjectRQ{}
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

	message := new(domain.DeleteProjectRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
	this.Data["Title"] = "The project deleted successfully."
	this.Data["Message"] = message.Message
	this.Data["Type"] = message.Status
	this.TplName = "Common/message.tpl"
}

func (this *ProjectController) GetResourcesByProject() {
	operation := "GetResourcesToProjects"

	input := domain.GetResourcesToProjectsRQ{}
	value, _ := this.GetInt64("ID")
	input.ProjectId = &value
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	fmt.Printf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesToProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("ResourcesToProjects", message.ResourcesToProjects)
		this.Data["ResourcesToProjects"] = message.ResourcesToProjects
		this.Data["Title"] = this.GetString("ProjectName")
		this.TplName = "Projects/listResourceByProject.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}
