package controllers

import (
	"encoding/json"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

type TrainingController struct {
	beego.Controller
}

func (this *TrainingController) ListTrainings() {
	operation := "GetTrainings"

	res, err := PostData(operation, nil)

	if err == nil {
		defer res.Body.Close()
		message := new(domain.TrainingRS)
		json.NewDecoder(res.Body).Decode(&message)

		// Set names for type and skill
		for _, training := range message.Trainings {
			for _, skill := range message.Skills {
				if skill.ID == training.SkillId {
					training.SkillName = skill.Name
				}
			}
			for _, _type := range message.Types {
				if _type.ID == training.TypeId {
					training.TypeName = _type.Name
				}
			}
		}

		this.Data["Trainings"] = message.Trainings
		this.Data["Types"] = message.Types
		this.Data["Skills"] = message.Skills
		this.Data["TypesSkills"] = message.TypesSkills

		this.TplName = "Training/listTrainings.tpl"

	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

/* Training Resources */
func (this *TrainingController) GetTrainingResources() {
	operation := "GetTrainingResources"
	input := domain.TrainingResourcesRQ{}
	err := this.ParseForm(&input)
	if err != nil {
		log.Error(err.Error())
	}
	log.Debugf("[ParseInput] Input: %+v \n", input)

	inputBuffer := EncoderInput(input)
	res, err := PostData(operation, inputBuffer)
	message := new(domain.TrainingResourcesRS)
	json.NewDecoder(res.Body).Decode(&message)

	if err == nil {
		defer res.Body.Close()
		this.Data["FilteredTrainings"] = message.FilteredTrainings
		this.Data["Trainings"] = message.Trainings
		this.Data["TResources"] = message.TrainingResources
		data := buildPieMessage(message.TrainingResources)
		this.Data["TStatus"] = data.SkillsName
		this.Data["TValues"] = data.SkillsValue

		this.Data["Resources"] = message.Resources
		this.Data["Types"] = message.Types
		this.Data["TypesSkills"] = message.TypesSkills

		this.TplName = "Training/Training.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}
}

func buildPieMessage(pMessage map[int]*domain.TrainingBreakdown) Datasets {
	trnTotal := map[string]int{}
	dataset := Datasets{}
	for _, trainingBD := range pMessage {
		for _, training := range trainingBD.TrainingResources {
			trnTotal[training.ResultStatus] = trnTotal[training.ResultStatus] + 1
		}
	}
	for status, total := range trnTotal {
		dataset.SkillsName = append(dataset.SkillsName, status)
		dataset.SkillsValue = append(dataset.SkillsValue, total)
	}

	return dataset
}

func (this *TrainingController) CreateTraining() {
	operation := "CreateTraining"

	input := domain.TrainingRQ{}
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

	message := new(domain.TrainingRS)
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

func (this *TrainingController) UpdateTraining() {
	operation := "UpdateTraining"

	input := domain.TrainingRQ{}
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
	message := new(domain.TrainingRS)
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

func (this *TrainingController) DeleteTraining() {
	operation := "DeleteTraining"

	input := domain.TrainingRQ{}
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

	message := new(domain.TrainingRS)
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

func (this *TrainingController) SetTrainingToResource() {
	operation := "SetTrainingToResource"

	input := domain.TrainingResourcesRQ{}
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

	message := new(domain.TrainingResourcesRS)
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

	/*if err == nil {

		this.TplName = "Training/Training.tpl"
	} else {
		this.Data["Title"] = "The Service is down."
		this.Data["Message"] = "Please contact with the system manager."
		this.Data["Type"] = "Error"
		this.TplName = "Common/message.tpl"
	}*/
}
