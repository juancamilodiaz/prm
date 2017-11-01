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
	operation := "GetTypes"
	res, err := PostData(operation, nil)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.TypeRS)
		json.NewDecoder(res.Body).Decode(&message)
		this.Data["Types"] = message.Types
		typesOf := ""
		for i, typeElement := range message.Types {
			if !strings.Contains(typesOf, typeElement.TypeOf) {
				if i != 0 {
					typesOf = typesOf + ";"
				}
				typesOf = typesOf + typeElement.TypeOf
			}
		}
		listTypeOf := strings.Split(typesOf, ";")
		this.Data["TypesOf"] = listTypeOf
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
}

func (this *TypeController) CreateType() {
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
}

func (this *TypeController) UpdateType() {
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
}

func (this *TypeController) DeleteType() {
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
}

func (this *TypeController) GetSkillsByType() {
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

}

func (this *TypeController) DeleteSkillsByType() {
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
}

func (this *TypeController) SetSkillToType() {

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
}

func buildChartMessageType(pMessage *domain.TypeSkillsRS) Datasets {

	dataset := Datasets{}
	for _, skill := range pMessage.TypeSkills {
		dataset.SkillsName = append(dataset.SkillsName, skill.Name)
		dataset.SkillsValue = append(dataset.SkillsValue, skill.Value)
	}

	return dataset
}
