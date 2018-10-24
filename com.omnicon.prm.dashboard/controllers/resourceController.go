package controllers

import (
	"encoding/json"
	"fmt"
	"sort"
	"strings"

	"github.com/astaxie/beego"
	"github.com/jinzhu/now"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type ResourceController struct {
	beego.Controller
}

var URL string = "http://" + serverip + ":10104/"
var URLProxy string = "http://" + serverip + ":" + proxyip + "/"

/*Index*/
func (this *ResourceController) Get() {
	this.Data["Website"] = "beego.me"
	this.Data["Email"] = "astaxie@gmail.com"
	this.TplName = "index.tpl"
	//TODO quitar website....
}

/* Resources */
func (this *ResourceController) ListResources() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetResources"

			res, err := PostData(operation, nil)

			if err == nil {
				defer res.Body.Close()
				message := new(domain.GetResourcesRS)
				json.NewDecoder(res.Body).Decode(&message)

				this.Data["Resources"] = message.Resources

				mapTypePerResource := make(map[int]map[int]string)

				for _, resource := range message.Resources {
					mapOfTypes := make(map[int]string)
					for _, resourceType := range resource.ResourceType {
						mapOfTypes[resourceType.TypeId] = resourceType.Name
					}
					mapTypePerResource[resource.ID] = mapOfTypes
				}

				this.Data["TypesResource"] = mapTypePerResource
				if this.GetString("Template") == "select" {
					this.TplName = "Projects/listResourceToDropDown.tpl"
				} else {
					this.TplName = "Resources/listResources.tpl"
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

func (this *ResourceController) ListTaskByResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetTaskByResources"

			res, err := PostData(operation, nil)

			if err == nil {
				defer res.Body.Close()
				message := new(domain.GetResourcesRS)
				json.NewDecoder(res.Body).Decode(&message)

				this.Data["Resources"] = message.Resources

				mapTypePerResource := make(map[int]map[int]string)

				for _, resource := range message.Resources {
					mapOfTypes := make(map[int]string)
					for _, resourceType := range resource.ResourceType {
						mapOfTypes[resourceType.TypeId] = resourceType.Name
					}
					mapTypePerResource[resource.ID] = mapOfTypes
				}

				this.Data["TypesResource"] = mapTypePerResource
				if this.GetString("Template") == "select" {
					this.TplName = "Projects/listResourceToDropDown.tpl"
				} else {
					this.TplName = "Resources/listResources.tpl"
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

func (this *ResourceController) CreateResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "CreateResource"

			input := domain.CreateResourceRQ{}
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

			message := new(domain.CreateResourceRS)
			err = json.NewDecoder(res.Body).Decode(&message)
			if err != nil {
				log.Error(err.Error())
			}

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

func (this *ResourceController) ReadResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetResources"

			input := domain.GetResourcesRQ{}
			err := this.ParseForm(&input)
			if err != nil {
				log.Error("[ParseInput]", input)
			}
			log.Debugf("[ParseInput] Input: %+v \n", input)

			inputBuffer := EncoderInput(input)

			res, err := PostData(operation, inputBuffer)

			if err == nil {
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
		} else if level > du {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ResourceController) ReadResourcePlanning() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetResources"

			input := domain.GetResourcesRQ{}
			err := this.ParseForm(&input)

			StartDate := now.BeginningOfWeek().String()
			startDateSplitted := strings.Split(StartDate, " ")

			EndDate := now.EndOfWeek().String()
			EndDateSplitted := strings.Split(EndDate, " ")

			input.TaskStartDate = startDateSplitted[0]
			input.TaskEndDate = EndDateSplitted[0]

			if err != nil {
				log.Error("[ParseInput]", input)
			}
			log.Debugf("[ParseInput] Input: %+v \n", input)

			inputBuffer := EncoderInput(input)

			res, err := PostData(operation, inputBuffer)

			if err == nil {
				defer res.Body.Close()
				message := new(domain.GetResourcesRS)
				json.NewDecoder(res.Body).Decode(&message)
				this.Data["StartDate"] = startDateSplitted[0]
				this.Data["EndDate"] = EndDateSplitted[0]
				this.Data["Resources"] = message.Resources
				this.TplName = "Resources/viewAssigments.tpl"
			} else {
				log.Error(err.Error())
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
func (this *ResourceController) UpdateResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "UpdateResource"

			input := domain.UpdateResourceRQ{}
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

			message := new(domain.UpdateResourceRS)
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

func (this *ResourceController) DeleteResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "DeleteResource"

			input := domain.DeleteResourceRQ{}
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

			message := new(domain.DeleteResourceRS)
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

func (this *ResourceController) GetSkillsByResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetSkillsByResource"

			input := domain.GetSkillByResourceRQ{}

			mapTypesResourceStr := this.GetString("MapTypesResource")
			fmt.Println(mapTypesResourceStr)
			err := this.ParseForm(&input)
			if err != nil {
				log.Error("[ParseInput]", input)
			}
			log.Debugf("[ParseInput] Input: %+v \n", input)

			inputBuffer := EncoderInput(input)

			res, err := PostData(operation, inputBuffer)

			var mapTypesResource map[int]string

			err = json.Unmarshal([]byte(mapTypesResourceStr), &mapTypesResource)

			if err == nil {
				defer res.Body.Close()
				message := new(domain.GetSkillByResourceRS)
				json.NewDecoder(res.Body).Decode(&message)
				data := buildChartMessage(message)
				this.Data["ResourceId"] = input.ID
				this.Data["Skills"] = message.Skills
				this.Data["Title"] = this.GetString("ResourceName")

				//Request skills by type
				operation = "GetSkillsByType"
				mapSkillsTypes := make(map[int]Datasets)
				for typeId, typeName := range mapTypesResource {
					inputType := domain.TypeRQ{}
					inputType.ID = typeId

					inputBuffer = EncoderInput(inputType)
					res, err = PostData(operation, inputBuffer)

					if err == nil {
						defer res.Body.Close()
						message := new(domain.TypeSkillsRS)
						json.NewDecoder(res.Body).Decode(&message)

						dataFromType := buildChartMessageType(message)
						dataFromType.TypeName = typeName
						mapSkillsTypes[typeId] = dataFromType
					}
				}

				//Add data from resource
				data.TypeName = this.GetString("ResourceName")
				mapSkillsTypes[0] = data

				mapSkillsAndValues, listTypesName := buildChartMessageWithType(mapSkillsTypes)
				//sort.Ints(mapSkillsAndValues["map"])

				//	fmt.Printf("%v", mapSkillsAndValues)
				this.Data["MapSkillsAndValues"] = mapSkillsAndValues

				var listSkills []string
				var listSkillsValue [][]int
				for skillName, _ := range mapSkillsAndValues {
					listSkills = append(listSkills, skillName)
				}
				//	sort.Strings(listTypesName)
				sort.Strings(listSkills)

				for index, _ := range listTypesName {
					var listTemp []int

					for _, nameSkill := range listSkills {
						listValues := mapSkillsAndValues[nameSkill]
						listTemp = append(listTemp, listValues[index])
					}
					listSkillsValue = append(listSkillsValue, listTemp)
				}

				fmt.Println("%v", listTypesName)
				fmt.Println("%v", listSkills)
				fmt.Println("%v", listSkillsValue)

				this.Data["ListSkills"] = listSkills
				this.Data["ListValues"] = listSkillsValue
				this.Data["ListTypesName"] = listTypesName

				listColors := []string{"Green", "Purple", "Blue", "Red", "Black", "Brown", "Gray", "Yellow", "Pink", "Aqua", "DarkCyan"}
				listBackgroundColors := []string{"rgba(31, 221, 40, 0.2)", "rgba(237, 21, 226, 0.2)", "rgba(80, 169, 224, 0.2)", "rgba(124, 124, 124, 0.2)", "rgba(244, 48, 48, 0.2)", "rgba(135, 115, 77, 0.2)", "rgba(196, 194, 190, 0.2)", "rgba(255, 255, 91, 0.2)", "rgba(249, 159, 239, 0.2)", "rgba(144, 244, 249, 0.2)", "rgba(18, 139, 145, 0.2)"}
				/*Set color again*/
				// TODO refactor this to assign ramdom colors.
				listColors = append(listColors, listColors...)
				listColors = append(listColors, listColors...)

				listBackgroundColors = append(listBackgroundColors, listBackgroundColors...)
				listBackgroundColors = append(listBackgroundColors, listBackgroundColors...)
				this.Data["ListColor"] = listColors
				this.Data["ListColorBkg"] = listBackgroundColors
				this.Data["MapTypesResource"] = mapTypesResource

				this.TplName = "Resources/listSkillsByResource.tpl"
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

type Datasets struct {
	TypeName    string
	SkillsName  []string
	SkillsValue []int
}

func buildChartMessage(pMessage *domain.GetSkillByResourceRS) Datasets {

	dataset := Datasets{}
	for _, skill := range pMessage.Skills {
		dataset.SkillsName = append(dataset.SkillsName, skill.Name)
		dataset.SkillsValue = append(dataset.SkillsValue, skill.Value)
	}

	return dataset
}

func buildChartMessageWithType(pMapSkillsTypes map[int]Datasets) (map[string][]int, []string) {

	mapResult := make(map[string][]int)
	var listTypeNames []string
	i := 0
	for _, dataSet := range pMapSkillsTypes {
		listTypeNames = append(listTypeNames, dataSet.TypeName)
		var totalSkillsValue []int
		for j, skillName := range dataSet.SkillsName {
			totalSkillsValue = mapResult[skillName]
			if i == 0 {
				totalSkillsValue = append(totalSkillsValue, dataSet.SkillsValue[j])
				mapResult[skillName] = totalSkillsValue
			} else if i > 0 {
				if len(totalSkillsValue)+1 < i+1 {
					for index := 0; index < i; index++ {
						totalSkillsValue = append(totalSkillsValue, 0)
					}
				}

				totalSkillsValue = append(totalSkillsValue, dataSet.SkillsValue[j])
				mapResult[skillName] = totalSkillsValue
			}

		}

		if i > 0 {
			for key, listValues := range mapResult {
				if len(listValues) < i+1 && len(listValues) == i {
					listValues = append(listValues, 0)
					mapResult[key] = listValues
				}
			}
		}
		i++
	}

	return mapResult, listTypeNames
}

func (this *ResourceController) SetSkillsToResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "SetSkillToResource"

			input := domain.SetSkillToResourceRQ{}
			err := this.ParseForm(&input)
			if err != nil {
				log.Error("[ParseInput]", input)
			}
			log.Debugf("[ParseInput] Input: %+v \n", input)

			inputBuffer := EncoderInput(input)

			res, err := PostData(operation, inputBuffer)

			if err == nil {
				defer res.Body.Close()

				this.Data["Title"] = this.GetString("ResourceName")
				this.TplName = "Resources/listSkillsByResource.tpl"
			} else {
				this.Data["Title"] = "The Service is down."
				this.Data["Message"] = "Please contact with the system manager."
				this.Data["Type"] = "Error"
				this.TplName = "Common/message.tpl"
			}
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ResourceController) DeleteSkillsToResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "DeleteSkillToResource"

			input := domain.DeleteSkillToResourceRQ{}
			err := this.ParseForm(&input)
			if err != nil {
				log.Error("[ParseInput]", input)
			}
			log.Debugf("[ParseInput] Input: %+v \n", input)

			inputBuffer := EncoderInput(input)

			res, err := PostData(operation, inputBuffer)

			defer res.Body.Close()
			message := new(domain.DeleteSkillToResourceRS)
			err = json.NewDecoder(res.Body).Decode(&message)
			if err == nil {
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
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ResourceController) GetTypesByResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetTypesByResource"

			input := domain.GetResourcesRQ{}
			err := this.ParseForm(&input)
			if err != nil {
				log.Error("[ParseInput]", input)
			}
			log.Debugf("[ParseInput] Input: %+v \n", input)

			inputBuffer := EncoderInput(input)

			res, err := PostData(operation, inputBuffer)

			if err == nil {
				defer res.Body.Close()
				message := new(domain.ResourceTypesRS)
				json.NewDecoder(res.Body).Decode(&message)
				this.Data["ResourceTypes"] = message.ResourceTypes
				typesResource := []*domain.Type{}
				for _, _types := range message.Types {
					if _types.ApplyTo == "Resource" {
						typesResource = append(typesResource, _types)
					}
				}
				this.Data["Types"] = typesResource
				this.Data["ResourceID"] = input.ID
				this.Data["Title"] = this.GetString("Description")
				this.TplName = "Resources/listResourceTypes.tpl"
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

func (this *ResourceController) DeleteTypesByResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "DeleteTypesByResource"

			input := domain.ResourceTypesRQ{}
			err := this.ParseForm(&input)
			if err != nil {
				log.Error("[ParseInput]", input)
			}
			log.Debugf("[ParseInput] Input: %+v \n", input)

			inputBuffer := EncoderInput(input)
			res, err := PostData(operation, inputBuffer)

			message := new(domain.ResourceTypesRS)
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

func (this *ResourceController) SetTypesToResource() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "SetTypesToResource"
			input := domain.ResourceTypesRQ{}

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

			message := new(domain.ResourceTypesRS)
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
