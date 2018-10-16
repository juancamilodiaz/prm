package controllers

import (
	"encoding/json"
	"math"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

type ProjectController struct {
	beego.Controller
}

/* Projects */
func (this *ProjectController) ListProjects() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
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

				typesProject := []*domain.Type{}
				for _, _type := range messageTypes.Types {
					if _type.ApplyTo == "Project" {
						typesProject = append(typesProject, _type)
					}
				}
				this.Data["Types"] = typesProject

				operation = "GetResources"

				input := domain.GetResourcesRQ{}
				enabled := true
				input.Enabled = &enabled

				inputBuffer := EncoderInput(input)
				res, _ = PostData(operation, inputBuffer)

				messageResources := new(domain.GetResourcesRS)
				json.NewDecoder(res.Body).Decode(&messageResources)

				this.Data["Resources"] = messageResources.Resources

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
		} else if level > du {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}

	}
	//body, _ := ioutil.ReadAll(res.Body)
}

func (this *ProjectController) CreateProject() {

	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {

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
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
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

	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
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

		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) DeleteProject() {

	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
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

		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) GetResourcesByProject() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetResourcesToProjects"

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
		} else if level > du {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) DeleteResourceToProject() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "DeleteResourceToProject"

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
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) SetResourceToProject() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
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
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) GetResourcesByProjectToday() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetResourcesToProjects"

			input := domain.GetResourcesToProjectsRQ{}
			input.Enabled = true
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
		} else if level > du {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) GetRecommendationResourcesByProject() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetResourcesToProjects"

			input := domain.GetResourcesToProjectsRQ{}
			input.Enabled = true
			idTypesString := this.GetString("Types")

			isSkillFilter, _ := this.GetBool("SkillsActive")

			isHoursFilter, _ := this.GetBool("HoursActive")
			hoursNumber, _ := this.GetInt("Hours")
			resourceNumber, _ := this.GetInt("NumberOfResources")

			err := this.ParseForm(&input)
			input.Hours = 0
			if err != nil {
				log.Error("[ParseInput]", input)
			}

			log.Debugf("[ParseInput] Input: %+v \n", input)

			if isHoursFilter {
				input.StartDate = util.GetFechaConFormato(time.Now().Unix(), util.DATEFORMAT)
				input.EndDate = util.GetFechaConFormato(util.AgregarORestaDiasAUnaFecha(time.Now().Unix(), hoursNumber), util.DATEFORMAT)
			}

			startDate := util.GetDateInt64FromString(input.StartDate)
			endDate := util.GetDateInt64FromString(input.EndDate)

			projectDays := util.CalcularDiasEntreDosFechas(startDate, endDate)

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
				this.Data["Resources"] = message.Resources
				this.Data["AvailBreakdown"] = message.AvailBreakdown
				this.Data["AvailBreakdownPerRange"] = message.AvailBreakdownPerRange

				// Set variable epsilon
				epsilonValue := message.EpsilonValue

				var listSorted []domain.ListByHours
				if isHoursFilter {
					listSorted = transformByHours(message.AvailBreakdownPerRange, hoursNumber, resourceNumber)
				}

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
				/*Set color again*/
				// TODO refactor this to assign ramdom colors.
				listColors = append(listColors, listColors...)
				listColors = append(listColors, listColors...)

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
							if message.AvailBreakdownPerRange[resource.ID] != nil {
								listResourceToDraw = append(listResourceToDraw, *resource)
							}
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
				if isHoursFilter {
					var resourcesSorted []*domain.Resource
					for _, resourceIdSorted := range listSorted {
						for _, resource := range message.Resources {
							if resourceIdSorted.ResourceId == resource.ID {
								resourcesSorted = append(resourcesSorted, resource)
							}
						}
					}
					this.Data["Resources"] = resourcesSorted
					this.Data["HoursByPerson"] = hoursNumber / resourceNumber
					this.TplName = "Projects/listRecommendResourcesTablePerHour.tpl"
				} else {
					//fmt.Println("------>", this.Data["AvailBreakdownPerRange"])
					this.Data["ProjectHours"] = projectDays * 8
					this.TplName = "Projects/listRecommendResourcesTable.tpl"
				}
			} else {
				this.Data["Title"] = "The Service is down."
				this.Data["Message"] = "Please contact with the system manager."
				this.Data["Type"] = "Error"
				this.TplName = "Common/message.tpl"
			}
		} else if level > du {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) GetTypesByProject() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
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

				typesProject := []*domain.Type{}
				for _, _types := range message.Types {
					if _types.ApplyTo == "Project" {
						typesProject = append(typesProject, _types)
					}
				}
				this.Data["Types"] = typesProject
				this.Data["ProjectID"] = input.ID
				this.Data["Title"] = this.GetString("Description")
				this.TplName = "Projects/listProjectTypes.tpl"
			} else {
				this.Data["Title"] = "The Service is down."
				this.Data["Message"] = "Please contact with the system manager."
				this.Data["Type"] = "Error"
				this.TplName = "Common/message.tpl"
			}
		} else if level > du {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) DeleteTypesByProject() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
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
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) SetTypesToProject() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
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
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) GetAssignationByResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetResourcesToProjects"

			input := domain.GetResourcesToProjectsRQ{}
			input.Enabled = true
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
		} else if level > du {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) Availability() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
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
			input.Enabled = true
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
				this.Data["DateFrom"] = input.StartDate
				this.Data["DateTo"] = input.EndDate
				//this.Data["AvailBreakdownPerRange"] = message.AvailBreakdownPerRange
				this.Data["Title"] = input.ProjectName
				this.TplName = "Projects/availability.tpl"

			} else {
				this.Data["Title"] = "The Service is down."
				this.Data["Message"] = "Please contact with the system manager."
				this.Data["Type"] = "Error"
				this.TplName = "Common/message.tpl"
			}
		} else if level > du {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ProjectController) AvailabileHours() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetResourcesToProjects"
			dateFrom, _ := time.Parse("2006-01-02", this.GetString("dateFrom"))
			dateTo := dateFrom.AddDate(0, 0, 5)

			input := domain.GetResourcesToProjectsRQ{}
			input.Enabled = true
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
				this.Data["Resources"] = message.Resources
				this.Data["AvailBreakdown"] = message.AvailBreakdown
				this.TplName = "Projects/availableHours.tpl"
			} else {
				this.Data["Title"] = "The Service is down."
				this.Data["Message"] = "Please contact with the system manager."
				this.Data["Type"] = "Error"
				this.TplName = "Common/message.tpl"
			}
		} else if level > du {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
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

func transformByHours(pMap map[int]*domain.ResourceAvailabilityInformation, pHours, pNumberResources int) []domain.ListByHours {
	var hoursRequired float64
	hoursRequired = float64(pHours) / float64(pNumberResources)

	var listSorted []domain.ListByHours
	temporalDays := 999
	temporalNumberRange := 999
	for resourceId, resourceInfo := range pMap {
		if resourceInfo.TotalHours >= hoursRequired {
			startDate := util.GetDateInt64FromString(resourceInfo.ListOfRange[0].StartDate)
			today := util.GetDateInt64FromString(util.GetFechaConFormato(time.Now().Unix(), util.DATEFORMAT))
			days := util.CalcularDiasEntreDosFechas(today, startDate)
			if days <= temporalDays {
				if days == temporalDays {
					if len(resourceInfo.ListOfRange) <= temporalNumberRange {
						resourceByHour := domain.ListByHours{}
						resourceByHour.ResourceId = resourceId
						resourceByHour.Days = days
						resourceByHour.NumberOfRange = len(resourceInfo.ListOfRange)
						listSorted = insertInList(listSorted, 0, resourceByHour)
					} else {
						resourceByHour := domain.ListByHours{}
						resourceByHour.ResourceId = resourceId
						resourceByHour.Days = days
						resourceByHour.NumberOfRange = len(resourceInfo.ListOfRange)
						listSorted = insertInList(listSorted, 1, resourceByHour)
					}
				} else {
					resourceByHour := domain.ListByHours{}
					resourceByHour.ResourceId = resourceId
					resourceByHour.Days = days
					resourceByHour.NumberOfRange = len(resourceInfo.ListOfRange)
					temporalNumberRange = resourceByHour.NumberOfRange
					listSorted = insertInList(listSorted, 0, resourceByHour)
				}
				temporalDays = days
			} else {
				pos := 0
				for index, value := range listSorted {
					if days <= value.Days {
						if days == value.Days && value.NumberOfRange < len(resourceInfo.ListOfRange) {
							pos = index + 1
							break
						} else {
							pos = index
							break
						}
					} else if index == len(listSorted)-1 {
						pos = index + 1
						break
					}
				}
				resourceByHour := domain.ListByHours{}
				resourceByHour.ResourceId = resourceId
				resourceByHour.Days = days
				resourceByHour.NumberOfRange = len(resourceInfo.ListOfRange)
				listSorted = insertInList(listSorted, pos, resourceByHour)
			}
		}
	}

	return listSorted
}

func insertInList(pList []domain.ListByHours, pPos int, pValueToInsert domain.ListByHours) []domain.ListByHours {
	position := int(math.Abs(float64(pPos)))
	var temporalList []domain.ListByHours
	if position > len(pList) {
		position = len(pList)
	}
	temporalList = append(temporalList, pList[position:]...)
	pList = append(pList[:position], pValueToInsert)
	pList = append(pList, temporalList...)

	return pList
}
