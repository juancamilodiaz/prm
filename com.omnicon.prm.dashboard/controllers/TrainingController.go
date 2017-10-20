package controllers

import (
	"encoding/json"
	//	"strconv"
	//"strings"
	//"time"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type TrainingController struct {
	beego.Controller
}

/* Projects */
func (this *TrainingController) GetTraining() {
	operation := "GetTraining"
	input := domain.TrainingRQ{}
	input.ID = 1
	err := this.ParseForm(&input)
	if err != nil {
		log.Error(err.Error())
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)
	res, err := PostData(operation, inputBuffer)
	message := new(domain.TrainingRS)
	json.NewDecoder(res.Body).Decode(&message)

	if err == nil {
		defer res.Body.Close()
		this.Data["Training"] = message.Training
		this.Data["TSkills"] = message.TrainingSkills
		data := buildPieMessage(message.TrainingSkills)
		this.Data["TStatus"] = data.SkillsName
		this.Data["TValues"] = data.SkillsValue

		this.Data["Resources"] = message.Resources
		this.Data["Types"] = message.Types

		this.TplName = "Training/Training.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func buildPieMessage(pMessage []*domain.TrainingSkills) Datasets {
	trnTotal := map[string]int{}
	dataset := Datasets{}
	for _, training := range pMessage {
		trnTotal[training.ResultStatus] = trnTotal[training.ResultStatus] + 1
	}
	for status, total := range trnTotal {
		dataset.SkillsName = append(dataset.SkillsName, status)
		dataset.SkillsValue = append(dataset.SkillsValue, total)
	}

	return dataset
}
