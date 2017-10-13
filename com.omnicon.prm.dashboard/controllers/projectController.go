package controllers

import (
	"encoding/json"
	"strconv"
	"strings"
	"time"

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
	if len(idstrg) > 0 {
		ids := strings.Split(idstrg, ",")
		input.ProjectType = ids
	}
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	if input.Name == "" {
		this.Data["Type"] = "Error"
		this.Data["Title"] = "Error in operation."
		this.Data["Message"] = "The name is empty."
		this.TplName = "Common/message.tpl"
		return
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
	id, _ := this.GetInt("ID")
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
		this.Data["AvailBreakdownPerRange"] = message.AvailBreakdownPerRange
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
	idTypesString := this.GetString("Types")

	isSkillFilter, _ := this.GetBool("SkillsActive")

	var epsilonValue float64
	epsilonValue = 10

	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)

	var idsType []string
	if idTypesString != "" {
		idsType = strings.Split(idTypesString, ",")
	}

	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetResourcesToProjectsRS)
		json.NewDecoder(res.Body).Decode(&message)

		this.Data["ResourcesToProjects"] = message.ResourcesToProjects
		this.Data["Projects"] = message.Projects
		var listResources []domain.Resource
		for _, resource := range message.Resources {
			listResources = append(listResources, *resource)
		}
		this.Data["DerefResources"] = listResources
		this.Data["Resources"] = message.Resources
		this.Data["AvailBreakdown"] = message.AvailBreakdown
		this.Data["AvailBreakdownPerRange"] = message.AvailBreakdownPerRange

		listSkillsPerProject := make(map[int]int)
		var listProjectsSkillName []string
		var listProjectsSkillValue []int

		for _, value := range idsType {
			skillsByTypeInput := domain.TypeRQ{}
			typeID, _ := strconv.Atoi(value)
			skillsByTypeInput.ID = typeID
			skillsByTypeInputBuffer := EncoderInput(skillsByTypeInput)

			resSkillsByType, errSkillsByType := PostData("GetSkillsByType", skillsByTypeInputBuffer)
			if errSkillsByType == nil {
				defer resSkillsByType.Body.Close()
				messageSkillsByType := new(domain.TypeSkillsRS)
				json.NewDecoder(resSkillsByType.Body).Decode(&messageSkillsByType)

				for _, skill := range messageSkillsByType.TypeSkills {
					listSkillsPerProject[skill.SkillId] = skill.Value
					listProjectsSkillName = append(listProjectsSkillName, skill.Name)
					listProjectsSkillValue = append(listProjectsSkillValue, skill.Value)
				}
			} else {
				this.Data["Title"] = "The Service is down."
				this.Data["Message"] = "Please contact with the system manager."
				this.Data["Type"] = "Error"
				this.TplName = "Common/message.tpl"
			}
		}

		listAbleResource := make(map[int]float64)
		listResourceToDraw := []domain.Resource{}
		mapCompare := make(map[int][]int)
		listColors := []string{"Black", "Orange", "Red", "Green", "Purple", "Brown", "Gray", "Yellow", "Pink", "Aqua", "DarkCyan"}

		for _, resource := range message.Resources {
			isAble := true
			average := 0.0
			count := 0
			if isSkillFilter {
				resourceSkillsInput := domain.GetSkillByResourceRQ{}
				resourceSkillsInput.ID = resource.ID
				resourceSkillsInputBuffer := EncoderInput(resourceSkillsInput)

				resResourceSkills, errResourceSkills := PostData("GetSkillsByResource", resourceSkillsInputBuffer)

				if errResourceSkills == nil {
					defer resResourceSkills.Body.Close()
					messageResourceSkills := new(domain.GetSkillByResourceRS)
					json.NewDecoder(resResourceSkills.Body).Decode(&messageResourceSkills)

					mapSkills := make(map[string]int)
					for skillID, skillValue := range listSkillsPerProject {
						stars := 0
						hasSkill := false
						for _, skillsByResource := range messageResourceSkills.Skills {
							if skillID == int(skillsByResource.SkillId) {
								mapSkills[skillsByResource.Name] = skillsByResource.Value
								if skillsByResource.Value >= skillValue {
									hasSkill = true
									stars = 4
									break
								}
								if skillsByResource.Value < skillValue && float64(skillsByResource.Value) >= float64(skillValue)-(epsilonValue*0.25) {
									hasSkill = true
									stars = 3
									break
								}
								if float64(skillsByResource.Value) < float64(skillValue)-(epsilonValue*0.25) && float64(skillsByResource.Value) >= float64(skillValue)-(epsilonValue*0.5) {
									hasSkill = true
									stars = 2
									break
								}
								if float64(skillsByResource.Value) < float64(skillValue)-(epsilonValue*0.5) && float64(skillsByResource.Value) >= float64(skillValue)-epsilonValue {
									hasSkill = true
									stars = 1
									break
								}
							} else {
								hasSkill = false
							}
						}
						if !hasSkill {
							isAble = false
							break
						} else {
							count += stars
						}
					}

					for _, skillName := range listProjectsSkillName {
						mapCompare[resource.ID] = append(mapCompare[resource.ID], mapSkills[skillName])
					}
				} else {
					this.Data["Title"] = "The Service is down."
					this.Data["Message"] = "Please contact with the system manager."
					this.Data["Type"] = "Error"
					this.TplName = "Common/message.tpl"
				}
			} else {
				listAbleResource[resource.ID] = 5
			}
			if isAble {
				if len(listSkillsPerProject) != 0 {
					average = float64(count / len(listSkillsPerProject))
					listAbleResource[resource.ID] = average
					listResourceToDraw = append(listResourceToDraw, *resource)
				}
			}

		}

		this.Data["AbleResource"] = listAbleResource
		this.Data["ListProjectSkillsName"] = listProjectsSkillName
		this.Data["ListProjectSkillsValue"] = listProjectsSkillValue
		this.Data["MapCompare"] = mapCompare
		this.Data["ListColor"] = listColors
		this.Data["ListChecked"] = []int{}
		this.Data["ListToDraw"] = listResourceToDraw
		this.TplName = "Projects/listRecommendResourcesTable.tpl"
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
		this.Data["Title"] = this.GetString("Description")
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
		this.Data["Title"] = input.ResourceName
		if input.ResourceName == "" {
			for _, assig := range message.ResourcesToProjects {
				this.Data["Title"] = assig.ResourceName
				break
			}
		}
		this.TplName = "Projects/listAssignationByResource.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func (this *ProjectController) Availability() {
	operation := "GetResourcesToProjects"
	y, w := time.Now().ISOWeek()
	dateFrom := FirstDayOfISOWeek(y, w, time.UTC)
	dateTo := dateFrom.AddDate(0, 0, 5)

	if this.Ctx.Input.IsPost() {
		this.Data["IsGet"] = false
	} else {
		this.Data["IsGet"] = true
	}

	input := domain.GetResourcesToProjectsRQ{}
	input.StartDate = dateFrom.Format("2006-01-02")
	input.EndDate = dateTo.Format("2006-01-02")

	dates := []string{}

	for i := 0; i < 5; i++ { //dateFrom.Before(dateTo) {
		dates = append(dates, dateFrom.Format("2006-01-02"))
		dateFrom = dateFrom.AddDate(0, 0, 1)
	}

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

		this.Data["Dates"] = dates
		//this.Data["ResourcesToProjects"] = message.ResourcesToProjects
		for _, project := range message.Projects {
			diff := project.EndDate.Sub(project.StartDate)
			days := int(diff.Hours() / 24)

			diff2 := time.Now().Sub(project.StartDate)
			days2 := int(diff2.Hours() / 24)

			f := float32(days2) / float32(days)
			project.Percent = int(f * float32(100))
		}

		this.Data["Projects"] = message.Projects
		this.Data["Resources"] = message.Resources
		this.Data["AvailBreakdown"] = message.AvailBreakdown
		//this.Data["AvailBreakdownPerRange"] = message.AvailBreakdownPerRange
		this.Data["Title"] = input.ProjectName
		this.TplName = "Projects/availability.tpl"

	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func FirstDayOfISOWeek(year int, week int, timezone *time.Location) time.Time {
	date := time.Date(year, 0, 0, 0, 0, 0, 0, timezone)
	isoYear, isoWeek := date.ISOWeek()

	// iterate back to Monday
	for date.Weekday() != time.Monday {
		date = date.AddDate(0, 0, -1)
		isoYear, isoWeek = date.ISOWeek()
	}

	// iterate forward to the first day of the first week
	for isoYear < year {
		date = date.AddDate(0, 0, 7)
		isoYear, isoWeek = date.ISOWeek()
	}

	// iterate forward to the first day of the given week
	for isoWeek < week {
		date = date.AddDate(0, 0, 7)
		isoYear, isoWeek = date.ISOWeek()
	}

	return date
}
