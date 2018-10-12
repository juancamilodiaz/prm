package controllers

import (
	"encoding/json"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type SkillController struct {
	beego.Controller
}

/*Index*/
func (this *SkillController) ListSkills() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetSkills"

			res, err := PostData(operation, nil)

			if err == nil {
				defer res.Body.Close()
				message := new(domain.GetSkillsRS)
				json.NewDecoder(res.Body).Decode(&message)

				this.Data["Skills"] = message.Skills
				if this.GetString("Template") == "select" {
					this.TplName = "Skills/listSkillToDropDown.tpl"
				} else {
					this.TplName = "Skills/listSkills.tpl"
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

func (this *SkillController) CreateSkill() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "CreateSkill"

			input := domain.CreateSkillRQ{}
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

			message := new(domain.CreateSkillRS)
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

func (this *SkillController) ReadSkill() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= du {
			operation := "GetSkills"

			input := domain.GetSkillsRQ{}
			err := this.ParseForm(&input)
			if err != nil {
				log.Error("[ParseInput]", input)
			}
			log.Debugf("[ParseInput] Input: %+v \n", input)

			inputBuffer := EncoderInput(input)

			res, err := PostData(operation, inputBuffer)

			if err == nil {
				defer res.Body.Close()
				message := new(domain.GetSkillsRS)
				json.NewDecoder(res.Body).Decode(&message)

				this.Data["Skills"] = message.Skills
				this.TplName = "Skills/viewSkills.tpl"
			} else {
				log.Error(err.Error())
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

func (this *SkillController) UpdateSkill() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "UpdateSkill"

			input := domain.UpdateSkillRQ{}
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
			message := new(domain.UpdateSkillRS)
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

func (this *SkillController) DeleteSkill() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			operation := "DeleteSkill"

			input := domain.DeleteSkillRQ{}
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

			message := new(domain.DeleteSkillRS)
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
