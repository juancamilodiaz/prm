package controllers

import (
	"encoding/json"
	"fmt"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type SkillController struct {
	beego.Controller
}

/*Index*/
func (this *SkillController) ListSkills() {
	operation := "GetSkills"

	res, err := PostData(operation, nil)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.GetSkillsRS)
		json.NewDecoder(res.Body).Decode(&message)
		fmt.Println("Skills", message.Skills)
		this.Data["Skills"] = message.Skills
		this.TplName = "Skills/listSkills.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func (this *SkillController) CreateSkill() {
	operation := "CreateSkill"

	input := domain.CreateSkillRQ{}
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

	message := new(domain.CreateSkillRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
	this.TplName = "Skills/listSkills.tpl"
}

func (this *SkillController) ReadSkill() {
	operation := "GetSkills"

	input := domain.GetSkillsRQ{}
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
}

func (this *SkillController) UpdateSkill() {
	operation := "UpdateSkill"

	input := domain.UpdateSkillRQ{}
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
	message := new(domain.UpdateSkillRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	if err != nil {
		log.Error(err.Error())
	}
	this.TplName = "Common/message.tpl"
}

func (this *SkillController) DeleteSkill() {
	operation := "DeleteSkill"

	input := domain.DeleteSkillRQ{}
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

	message := new(domain.DeleteSkillRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
	this.TplName = "Common/message.tpl"
}
