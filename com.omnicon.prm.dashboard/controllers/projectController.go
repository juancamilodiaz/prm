package controllers

import (
	"encoding/json"
	"strings"

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

		operation = "GetTypes"
		res, err = PostData(operation, nil)
		messageTypes := new(domain.TypeRS)
		json.NewDecoder(res.Body).Decode(&messageTypes)
		this.Data["Types"] = messageTypes.Types

		this.Data["Projects"] = message.Projects

		if this.GetString("Template") == "select" {
			this.TplName = "Projects/listProjectsToDropDown.tpl"
		} else {
			this.TplName = "Projects/listProjects.tpl"
		}
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

	idstrg := this.GetString("ProjectType")
	ids := strings.Split(idstrg, ",")
	input.ProjectType = ids
	if err != nil {
		log.Error("[ParseInput]", input)
	}

	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)
	res, err := PostData(operation, inputBuffer)

	if err != nil {
		log.Error(err.Error())
	}

	defer res.Body.Close()
	message := new(domain.CreateProjectRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	if err != nil {
		log.Error(err.Error())
	}
	if message.Status == "Error" {
		this.Data["Type"] = message.Status
		this.Data["Title"] = "Error in operation."
		this.Data["Message"] = message.Message
		this.TplName = "Common/message.tpl"
	} else if message.Status == "OK" {
		this.Data["Type"] = "Success"
		this.Data["Title"] = "Operation Success"
		this.TplName = "Common/message.tpl"
	} else {
		this.TplName = "Common/empty.tpl"
	}
}

func (this *ProjectController) ReadProject() {
	operation := "GetProjects"

	input := domain.GetProjectsRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)
	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)

		operation = "getTypes"
		res, err = PostData(operation, nil)

		messageTypes := new(domain.TypeRS)
		json.NewDecoder(res.Body).Decode(&messageTypes)
		this.Data["Types"] = messageTypes.Types
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
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)
	if err != nil {
		log.Error(err.Error())
	}

	defer res.Body.Close()
	message := new(domain.UpdateProjectRS)
	err = json.NewDecoder(res.Body).Decode(&message)

	if err != nil {
		log.Error(err.Error())
	}
	if message.Status == "Error" {
		this.Data["Type"] = message.Status
		this.Data["Title"] = "Error in operation."
		this.Data["Message"] = message.Message
		this.TplName = "Common/message.tpl"
	} else if message.Status == "OK" {
		this.Data["Type"] = "Success"
		this.Data["Title"] = "Operation Success"
		this.TplName = "Common/message.tpl"
	} else {
		this.TplName = "Common/empty.tpl"
	}
}

func (this *ProjectController) DeleteProject() {
	operation := "DeleteProject"

	input := domain.DeleteProjectRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.DeleteProjectRS)
	err = json.NewDecoder(res.Body).Decode(&message)

	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}

	if message.Status == "Error" {
		this.Data["Type"] = message.Status
		this.Data["Title"] = "Error in operation."
		this.Data["Message"] = message.Message
		this.TplName = "Common/message.tpl"
	} else if message.Status == "OK" {
		this.Data["Type"] = "Success"
		this.Data["Title"] = "Operation Success"
		this.TplName = "Common/message.tpl"
	} else {
		this.TplName = "Common/empty.tpl"
	}
}

func (this *ProjectController) GetResourcesByProject() {
	operation := "GetResourcesToProjects"

	input := domain.GetResourcesToProjectsRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesToProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)
		this.Data["ResourcesToProjects"] = message.ResourcesToProjects

		for _, rp := range message.Projects {
			if input.ProjectId == rp.ID {

				this.Data["Title"] = rp.Name
				this.Data["StartDate"] = rp.StartDate
				this.Data["EndDate"] = rp.EndDate
				break
			}
		}
		this.Data["ProjectId"] = input.ProjectId
		//this.Data["Title"] = input.ProjectName
		this.TplName = "Projects/listResourceByProject.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (this *ProjectController) DeleteResourceToProject() {
	operation := "DeleteResourceToProject"

	input := domain.DeleteResourceToProjectRQ{}
	id, _ := this.GetInt64("ID")
	input.ID = id

	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesToProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)
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

func (this *ProjectController) SetResourceToProject() {
	operation := "SetResourceToProject"

	input := domain.SetResourceToProjectRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.SetResourceToProjectRS)
		json.NewDecoder(res.Body).Decode(&message)
		this.Data["Project"] = message.Project
		this.Data["ProjectId"] = input.ProjectId
		if message.Project != nil {
			this.Data["Title"] = message.Project.Name
		}
		if message.Status == "Error" {
			this.Data["Type"] = message.Status
			this.Data["Title"] = "Error in operation."
			this.Data["Message"] = message.Message
			this.TplName = "Common/message.tpl"
		} else {
			this.TplName = "Common/empty.tpl"
		}
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (this *ProjectController) GetResourcesByProjectToday() {
	operation := "GetResourcesToProjects"

	input := domain.GetResourcesToProjectsRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesToProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)
		this.Data["ResourcesToProjects"] = message.ResourcesToProjects
		this.Data["Projects"] = message.Projects
		this.Data["Resources"] = message.Resources
		this.Data["AvailBreakdown"] = message.AvailBreakdown
		this.Data["Title"] = input.ProjectName
		this.TplName = "Projects/listResourceByProjectToday.tpl"

	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func (this *ProjectController) GetRecommendationResourcesByProject() {
	operation := "GetResourcesToProjects"

	input := domain.GetResourcesToProjectsRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesToProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)

		this.Data["ResourcesToProjects"] = message.ResourcesToProjects
		this.Data["Projects"] = message.Projects
		this.Data["Resources"] = message.Resources
		this.Data["AvailBreakdown"] = message.AvailBreakdown
		this.Data["AvailBreakdownPerRange"] = message.AvailBreakdownPerRange
		this.TplName = "Projects/listRecommendResources.tpl"

	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}
func (this *ProjectController) GetTypesByProject() {
	operation := "GetTypesByProject"

	input := domain.GetProjectsRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.ProjectTypesRS)
		json.NewDecoder(res.Body).Decode(&message)
		this.Data["ProjectTypes"] = message.ProjectTypes
		this.Data["Types"] = message.Types
		this.Data["ProjectID"] = input.ID
		this.Data["Title"] = "Types " + this.GetString("Description")
		this.TplName = "Projects/listProjectTypes.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func (this *ProjectController) DeleteTypesByProject() {
	operation := "DeleteTypesByProject"

	input := domain.ProjectTypesRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)
	res, err := PostData(operation, inputBuffer)

	message := new(domain.ProjectTypesRS)
	err = json.NewDecoder(res.Body).Decode(&message)

	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}

	if message.Status == "Error" {
		this.Data["Type"] = message.Status
		this.Data["Title"] = "Error in operation."
		this.Data["Message"] = message.Message
		this.TplName = "Common/message.tpl"
	} else if message.Status == "OK" {
		this.Data["Type"] = "Success"
		this.Data["Title"] = "Operation Success"
		this.TplName = "Common/message.tpl"
	} else {
		this.TplName = "Common/empty.tpl"
	}
}

func (this *ProjectController) SetTypesToProject() {
	operation := "SetTypesToProject"
	input := domain.ProjectTypesRQ{}

	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}

	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)
	res, err := PostData(operation, inputBuffer)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.ProjectTypesRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}

	if message.Status == "Error" {
		this.Data["Type"] = message.Status
		this.Data["Title"] = "Error in operation."
		this.Data["Message"] = message.Message
		this.TplName = "Common/message.tpl"
	} else if message.Status == "OK" {
		this.Data["Type"] = "Success"
		this.Data["Title"] = "Operation Success"
		this.TplName = "Common/message.tpl"
	} else {
		this.TplName = "Common/empty.tpl"
	}
}

func (this *ProjectController) GetAssignationByResource() {
	operation := "GetResourcesToProjects"

	input := domain.GetResourcesToProjectsRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesToProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)
		this.Data["ResourcesToProjects"] = message.ResourcesToProjects
		this.Data["ResourceId"] = input.ResourceId
		for _, assig := range message.ResourcesToProjects {
			this.Data["Title"] = assig.ResourceName
			break
		}
		this.TplName = "Projects/listAssignationByResource.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}