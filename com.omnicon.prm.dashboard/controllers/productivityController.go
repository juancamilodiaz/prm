package controllers

import (
	"encoding/json"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
)

type ProductivityController struct {
	beego.Controller
}

func (this *ProductivityController) ListProductivity() {

	input := domain.ProductivityTasksRQ{}
	this.ParseForm(&input)

	// Get projects enabled
	operationProjects := "GetProjects"
	requestProjects := domain.GetProjectsRQ{}
	enabled := true
	requestProjects.Enabled = &enabled

	inputBufferProjects := EncoderInput(requestProjects)

	resProjects, _ := PostData(operationProjects, inputBufferProjects)

	messageProjects := new(domain.GetProjectsRS)
	err := json.NewDecoder(resProjects.Body).Decode(&messageProjects)

	if err == nil {
		defer resProjects.Body.Close()

		this.Data["Projects"] = messageProjects.Projects

		if input.ProjectID != 0 {

			this.Data["ProjectID"] = input.ProjectID

			operationTasks := "GetProductivityTasks"
			requestTasks := domain.ProductivityTasksRQ{}
			// Set project id for tasks
			requestTasks.ProjectID = input.ProjectID

			inputBufferTasks := EncoderInput(requestTasks)

			resTasks, _ := PostData(operationTasks, inputBufferTasks)

			messageTasks := new(domain.ProductivityTasksRS)
			defer resTasks.Body.Close()
			json.NewDecoder(resTasks.Body).Decode(&messageTasks)

			labels := []string{}
			data := []float64{}
			for _, task := range messageTasks.ProductivityTasks {
				labels = append(labels, task.Name)
				data = append(data, task.TotalExecute)
			}
			this.Data["TLabels"] = labels
			this.Data["TValues"] = data

			this.Data["ProductivityTasks"] = messageTasks.ProductivityTasks
			this.Data["ResourceReports"] = messageTasks.ResourceReports

			operationResources := "GetResourcesToProjects"
			requestResources := domain.GetResourcesToProjectsRQ{}
			requestResources.ProjectId = input.ProjectID

			inputBufferResources := EncoderInput(requestResources)
			resResources, _ := PostData(operationResources, inputBufferResources)

			messageResources := new(domain.GetResourcesToProjectsRS)
			defer resResources.Body.Close()
			json.NewDecoder(resResources.Body).Decode(&messageResources)

			// only resources of assignations
			resources := []*domain.Resource{}
			for _, resource := range messageResources.Resources {
				for _, assignation := range messageResources.ResourcesToProjects {
					if resource.ID == assignation.ResourceId {
						resources = append(resources, resource)
						break
					}
				}
			}
			this.Data["Resources"] = resources

		}

		this.TplName = "Productivity/ProductivityReport.tpl"

	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func (this *ProductivityController) CreateTask() {
	operation := "CreateProductivityTasks"

	input := domain.ProductivityTasksRQ{}
	this.ParseForm(&input)

	inputBuffer := EncoderInput(input)

	res, _ := PostData(operation, inputBuffer)

	message := new(domain.ProductivityTasksRS)
	json.NewDecoder(res.Body).Decode(&message)

	defer res.Body.Close()

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

func (this *ProductivityController) UpdateTask() {
	operation := "UpdateProductivityTasks"

	input := domain.ProductivityTasksRQ{}
	this.ParseForm(&input)

	inputBuffer := EncoderInput(input)

	res, _ := PostData(operation, inputBuffer)

	message := new(domain.ProductivityTasksRS)
	json.NewDecoder(res.Body).Decode(&message)

	defer res.Body.Close()

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

func (this *ProductivityController) DeleteTask() {
	operation := "DeleteProductivityTasks"

	input := domain.ProductivityTasksRQ{}
	this.ParseForm(&input)

	inputBuffer := EncoderInput(input)

	res, _ := PostData(operation, inputBuffer)

	message := new(domain.ProductivityTasksRS)
	json.NewDecoder(res.Body).Decode(&message)

	defer res.Body.Close()

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

func (this *ProductivityController) CreateReport() {
	operation := "CreateProductivityReport"

	input := domain.ProductivityReportRQ{}
	this.ParseForm(&input)

	inputBuffer := EncoderInput(input)

	res, _ := PostData(operation, inputBuffer)

	message := new(domain.ProductivityReportRS)
	json.NewDecoder(res.Body).Decode(&message)

	defer res.Body.Close()

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

func (this *ProductivityController) UpdateReport() {
	operation := "UpdateProductivityReport"

	input := domain.ProductivityReportRQ{}
	this.ParseForm(&input)

	inputBuffer := EncoderInput(input)

	res, _ := PostData(operation, inputBuffer)

	message := new(domain.ProductivityReportRS)
	json.NewDecoder(res.Body).Decode(&message)

	defer res.Body.Close()

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

func (this *ProductivityController) DeleteReport() {
	operation := "DeleteProductivityReport"

	input := domain.ProductivityReportRQ{}
	this.ParseForm(&input)

	inputBuffer := EncoderInput(input)

	res, _ := PostData(operation, inputBuffer)

	message := new(domain.ProductivityReportRS)
	json.NewDecoder(res.Body).Decode(&message)

	defer res.Body.Close()

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
