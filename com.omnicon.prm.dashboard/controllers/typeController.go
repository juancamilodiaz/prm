package controllers

import (
	"encoding/json"
	"strings"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type TypeController struct {
	beego.Controller
}

/*Index*/
func (this *TypeController) ListTypes() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetTypes"
			res, err := PostData(operation, nil)

			if err == nil {
				defer res.Body.Close()
				message := new(domain.TypeRS)
				json.NewDecoder(res.Body).Decode(&message)
				this.Data["Types"] = message.Types
				applyTo := ""
				for i, typeElement := range message.Types {
					if !strings.Contains(applyTo, typeElement.ApplyTo) {
						if i != 0 {
							applyTo = applyTo + ";"
						}
						applyTo = applyTo + typeElement.ApplyTo
					}
				}
				listApplyTo := strings.Split(applyTo, ";")
				this.Data["ListApplyTo"] = listApplyTo
				if this.GetString("Template") == "types" {
					this.Data["ResourcesToProjects"] = nil
					this.Data["Projects"] = nil
					this.Data["Resources"] = nil
					this.Data["AvailBreakdown"] = nil
					this.Data["AvailBreakdownPerRange"] = nil
					this.Data["AbleResource"] = nil
					this.TplName = "Projects/listRecommendResources.tpl"
				} else {
					this.TplName = "Types/listTypes.tpl"
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

func (this *TypeController) CreateType() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "CreateType"

			input := domain.TypeRQ{}
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

			message := new(domain.TypeRS)
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

func (this *TypeController) UpdateType() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "UpdateType"

			input := domain.TypeRQ{}
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
			message := new(domain.TypeRS)
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

func (this *TypeController) DeleteType() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "DeleteType"

			input := domain.TypeRQ{}
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

			message := new(domain.TypeRS)
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

func (this *TypeController) GetSkillsByType() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetSkillsByType"

			input := domain.TypeRQ{}
			err := this.ParseForm(&input) //filter by TypeId
			if err != nil {
				log.Error("[ParseInput]", input)
			}
			log.Debugf("[ParseInput] Input: %+v \n", input)

			inputBuffer := EncoderInput(input)

			res, err := PostData(operation, inputBuffer)

			if err == nil {
				defer res.Body.Close()
				message := new(domain.TypeSkillsRS)
				json.NewDecoder(res.Body).Decode(&message)

				data := buildChartMessageType(message)

				this.Data["SkillsName"] = data.SkillsName
				this.Data["SkillsValue"] = data.SkillsValue

				this.Data["TypeID"] = input.ID
				this.Data["TypeSkills"] = message.TypeSkills
				this.Data["Skills"] = message.Skills
				this.Data["Title"] = this.GetString("Description")
				this.TplName = "Types/listSkillsByType.tpl"
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

func (this *TypeController) DeleteSkillsByType() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "DeleteSkillsByType"
			input := domain.TypeSkillsRQ{}
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

			message := new(domain.TypeSkillsRS)
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

func (this *TypeController) SetSkillToType() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "SetSkillsToType"
			input := domain.TypeSkillsRQ{}
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

			message := new(domain.TypeSkillsRS)
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

func buildChartMessageType(pMessage *domain.TypeSkillsRS) Datasets {

	dataset := Datasets{}
	for _, skill := range pMessage.TypeSkills {
		dataset.SkillsName = append(dataset.SkillsName, skill.Name)
		dataset.SkillsValue = append(dataset.SkillsValue, skill.Value)
	}

	return dataset
}
