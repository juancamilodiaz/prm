package controllers

import (
	"encoding/json"
	"fmt"
	"strings"

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

	payload := strings.NewReader("{" +
		"\n\t\"Name\":\"" + this.GetString("Name") + "\"" +
		"\n}")
	fmt.Println(payload)

	res, err := PostData(operation, payload)

	message := new(domain.GetSkillsRS)
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

	payload := strings.NewReader("{\n\t\"Id\":" + this.Ctx.Input.Param(":id") + "\n}")
	res, err := PostData(operation, payload)

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

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + this.GetString("ID") + "," +
		"\n\t\"Name\":\"" + this.GetString("Name") + "\"" + "\n}")

	fmt.Println(payload)

	res, err := PostData(operation, payload)
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

}

func (this *SkillController) DeleteSkill() {
	operation := "DeleteSkill"

	payload := strings.NewReader("{" +
		"\n\t\"ID\":" + this.GetString("ID") +
		"\n}")
	fmt.Println(payload)

	res, err := PostData(operation, payload)
	if err != nil {
		log.Error(err.Error())
	}

	message := new(domain.GetSkillsRS)
	err = json.NewDecoder(res.Body).Decode(&message)
	fmt.Println(message)
	defer res.Body.Close()
	if err != nil {
		log.Error(err.Error())
	}
}
