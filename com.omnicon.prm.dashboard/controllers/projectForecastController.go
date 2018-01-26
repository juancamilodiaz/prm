package controllers

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type ProjectForecastController struct {
	beego.Controller
}

/* Projects Forecast */
func (this *ProjectForecastController) ListProjectsForecast() {
	operation := "GetProjectsForecast"

	res, err := PostData(operation, nil)

	defaultValue, _ := this.GetBool("default")

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetProjectsForecastRS)
		json.NewDecoder(res.Body).Decode(&message)

		operation = "GetTypes"
		res, err = PostData(operation, nil)
		messageTypes := new(domain.TypeRS)
		json.NewDecoder(res.Body).Decode(&messageTypes)

		typesProject := []*domain.Type{}
		typesResources := []*domain.Type{}
		for _, _type := range messageTypes.Types {
			if _type.ApplyTo == "Project" {
				typesProject = append(typesProject, _type)
			} else {
				typesResources = append(typesResources, _type)
			}
		}
		this.Data["Types"] = typesProject
		this.Data["TypesResources"] = typesResources
		this.Data["Default"] = defaultValue

		operation = "GetResources"

		input := domain.GetResourcesRQ{}
		enabled := true
		input.Enabled = &enabled

		inputBuffer := EncoderInput(input)
		res, _ = PostData(operation, inputBuffer)

		messageResources := new(domain.GetResourcesRS)
		json.NewDecoder(res.Body).Decode(&messageResources)

		this.Data["Resources"] = messageResources.Resources

		this.Data["ProjectsForecast"] = message.ProjectForecast

		/*********/
		years := make(map[int]map[int]*domain.UsageByWeek)
		MOMType := ""
		DEVType := ""
		for _, typee := range messageTypes.Types {
			if typee.Name == "MOM Engineer" {
				MOMType = "MOM Engineer"
			}
			if typee.Name == "Developer" {
				DEVType = "Developer"
			}
		}

		for _, forecastProject := range message.ProjectForecast {
			startYear, startWeek := forecastProject.StartDate.ISOWeek()
			endYear, endWeek := forecastProject.EndDate.ISOWeek()

			if startYear == endYear {
				for week := startWeek; week <= endWeek; week++ {
					weekRegister := make(map[int]*domain.UsageByWeek)
					year := startYear
					usage := domain.UsageByWeek{}
					for _, assign := range forecastProject.AssignResources {
						if assign.Name == MOMType {
							usage.MOM = assign.NumberResources
						}
						if assign.Name == DEVType {
							usage.DEV = assign.NumberResources
						}
					}

					var currentDate time.Time
					currentDate = FirstDayOfISOWeek(startYear, week, time.Local)
					if week < startWeek {
						year = endYear
						currentDate = FirstDayOfISOWeek(endYear, week, time.Local)
					}
					usage.Month = currentDate.Month()
					older := weekRegister[week]
					if older != nil {
						older.DEV += usage.DEV
						older.MOM += usage.MOM
					} else {
						weekRegister[week] = &usage
					}

					olderYear := years[year]
					if olderYear != nil {
						if years[year][week] != nil {
							years[year][week].DEV += weekRegister[week].DEV
							years[year][week].MOM += weekRegister[week].MOM
						} else {
							years[year][week] = weekRegister[week]
						}
					} else {
						years[year] = weekRegister
					}
				}
			} else if startYear < endYear {
				lastDayOfYear := time.Date(startYear, time.December, 31, 0, 0, 0, 0, time.Local)
				_, endWeekOfYear := lastDayOfYear.ISOWeek()
				for week := startWeek; week <= endWeekOfYear; week++ {
					weekRegister := make(map[int]*domain.UsageByWeek)
					year := startYear
					usage := domain.UsageByWeek{}
					for _, assign := range forecastProject.AssignResources {
						if assign.Name == MOMType {
							usage.MOM = assign.NumberResources
						}
						if assign.Name == DEVType {
							usage.DEV = assign.NumberResources
						}
					}

					var currentDate time.Time
					currentDate = FirstDayOfISOWeek(startYear, week, time.Local)
					if week < startWeek {
						year = endYear
						currentDate = FirstDayOfISOWeek(endYear, week, time.Local)
					}
					usage.Month = currentDate.Month()
					older := weekRegister[week]
					if older != nil {
						older.DEV += usage.DEV
						older.MOM += usage.MOM
					} else {
						weekRegister[week] = &usage
					}

					olderYear := years[year]
					if olderYear != nil {
						if years[year][week] != nil {
							years[year][week].DEV += weekRegister[week].DEV
							years[year][week].MOM += weekRegister[week].MOM
						} else {
							years[year][week] = weekRegister[week]
						}
					} else {
						years[year] = weekRegister
					}
				}

				for week := 1; week <= endWeek; week++ {
					weekRegister := make(map[int]*domain.UsageByWeek)
					year := startYear
					usage := domain.UsageByWeek{}
					for _, assign := range forecastProject.AssignResources {
						if assign.Name == MOMType {
							usage.MOM = assign.NumberResources
						}
						if assign.Name == DEVType {
							usage.DEV = assign.NumberResources
						}
					}

					var currentDate time.Time
					currentDate = FirstDayOfISOWeek(startYear, week, time.Local)
					if week < startWeek {
						year = endYear
						currentDate = FirstDayOfISOWeek(endYear, week, time.Local)
					}
					usage.Month = currentDate.Month()
					older := weekRegister[week]
					if older != nil {
						older.DEV += usage.DEV
						older.MOM += usage.MOM
					} else {
						weekRegister[week] = &usage
					}

					olderYear := years[year]
					if olderYear != nil {
						if years[year][week] != nil {
							years[year][week].DEV += weekRegister[week].DEV
							years[year][week].MOM += weekRegister[week].MOM
						} else {
							years[year][week] = weekRegister[week]
						}
					} else {
						years[year] = weekRegister
					}
				}
			}
		}

		for year, mapYear := range years {
			fmt.Println(year, ": {")
			for week, mapWeek := range mapYear {
				fmt.Println("		", week, ": {")
				fmt.Println("			", "Month:", mapWeek.Month)
				fmt.Println("			", "DEV:", mapWeek.DEV)
				fmt.Println("			", "MOM:", mapWeek.MOM)
				fmt.Println("		}")
			}
			fmt.Println("}")
		}

		tableWorkLoad := make(map[int]map[string]*domain.UsageByWeek)
		for year, mapYear := range years {
			yearWorkLoad := make(map[string]*domain.UsageByWeek)
			for _, mapWeek := range mapYear {
				if yearWorkLoad[mapWeek.Month.String()] == nil {
					obj := domain.UsageByWeek{}
					obj.DEV = mapWeek.DEV
					obj.MOM = mapWeek.MOM
					obj.Month = mapWeek.Month

					yearWorkLoad[mapWeek.Month.String()] = &obj
				} else {
					if yearWorkLoad[mapWeek.Month.String()].DEV < mapWeek.DEV {
						yearWorkLoad[mapWeek.Month.String()].DEV = mapWeek.DEV
					}
					if yearWorkLoad[mapWeek.Month.String()].MOM < mapWeek.MOM {
						yearWorkLoad[mapWeek.Month.String()].MOM = mapWeek.MOM
					}
				}
			}
			tableWorkLoad[year] = yearWorkLoad
		}

		for year, mapYear := range tableWorkLoad {
			fmt.Println(year, ": {")
			for month, mapWeek := range mapYear {
				fmt.Println("		", month, ": {")
				fmt.Println("			", "Month:", mapWeek.Month)
				fmt.Println("			", "DEV:", mapWeek.DEV)
				fmt.Println("			", "MOM:", mapWeek.MOM)
				fmt.Println("		}")
			}
			fmt.Println("}")
		}

		numberOfYears := len(tableWorkLoad)
		months := []string{}
		referenceDate := time.Date(1970, time.January, 1, 0, 0, 0, 0, time.Local)
		for year, _ := range tableWorkLoad {
			for i := 0; i < 12; i++ {
				months = append(months, referenceDate.Month().String()+" - "+strconv.Itoa(year))
				referenceDate = referenceDate.AddDate(0, 1, 0)
			}
		}
		/*********/

		getWorkLoad(message.ProjectForecast)

		//if this.GetString("Template") == "select" {
		//this.TplName = "Projects/listProjectsToDropDown.tpl"
		//} else {
		this.TplName = "ProjectsForecast/listProjectsForecast.tpl"
		//}
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (this *ProjectForecastController) CreateProjectForecast() {

	operation := "CreateProjectForecast"
	input := domain.ProjectForecastRQ{}

	err := this.ParseForm(&input)

	idstrg := this.GetString("ProjectType")
	if len(idstrg) > 0 {
		ids := strings.Split(idstrg, ",")
		input.Types = ids
	}
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
	message := new(domain.CreateProjectForecastRS)
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

func (this *ProjectForecastController) ReadProjectForecast() {
	operation := "GetProjectsForecast"

	input := domain.ProjectForecastRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error("[ParseInput]", input)
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)
	res, err := PostData(operation, inputBuffer)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetProjectsForecastRS)
		json.NewDecoder(res.Body).Decode(&message)

		operation = "getTypes"
		res, err = PostData(operation, nil)

		messageTypes := new(domain.TypeRS)
		json.NewDecoder(res.Body).Decode(&messageTypes)
		this.Data["Types"] = messageTypes.Types
		this.Data["ProjectsForecast"] = message.ProjectForecast
		this.TplName = "ProjectsForecast/viewProjectsForecast.tpl"
	} else {
		log.Error(err.Error())
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (this *ProjectForecastController) UpdateProjectForecast() {
	operation := "UpdateProjectForecast"

	input := domain.ProjectForecastRQ{}
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
	message := new(domain.UpdateProjectForecastRS)
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

func (this *ProjectForecastController) DeleteProjectForecast() {
	operation := "DeleteProjectForecast"

	input := domain.ProjectForecastRQ{}
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

	message := new(domain.DeleteProjectForecastRS)
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

func (this *ProjectForecastController) GetAssignsByProjectForecast() {
	operation := "GetAssignsToProjectsForecast"

	input := domain.GetResourcesToProjectsRQ{}
	input.Enabled = false
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

func (this *ProjectForecastController) DeleteAssignsToProjectForecast() {
	operation := "DeleteAssignsToProjectForecast"

	input := domain.DeleteResourceToProjectRQ{}
	id, _ := this.GetInt("ID")
	if id != 0 {
		input.IDs = append(input.IDs, id)
	} else {
		idsStr := this.GetString("IDs")
		ids := strings.Split(idsStr, ",")
		for _, idStr := range ids {
			id, _ := strconv.Atoi(idStr)
			input.IDs = append(input.IDs, id)
		}
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

func (this *ProjectForecastController) SetResourceToProject() {
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

func getWorkLoad(pProjectForecast []*domain.ProjectForecast) {

}
