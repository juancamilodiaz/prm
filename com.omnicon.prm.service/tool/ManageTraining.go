package tool

import (
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

/**
* Function to create a new Training from TrainingRQ
 */
func CreateTraining(pRequest *DOMAIN.TrainingRQ) *DOMAIN.TrainingRS {
	timeResponse := time.Now()
	training := util.MappingTrainingRQ(pRequest)
	id, err := dao.AddTraining(training)
	// Create response
	response := DOMAIN.TrainingRS{}
	if err != nil {
		message := "Taining wasn't insert"
		log.Error(message)
		response.Message = message
		//response.Trainings = nil
		response.Status = "Error"
		return &response
	}
	// Get Taining inserted
	//training = dao.GetTrainingsById(id)
	trainingSkill := util.MappingTrainingSkills(id, pRequest.TrainingSkills)
	err = dao.AddBulkTrainingSkills(trainingSkill)
	if err != nil {
		message := "TainingSkills wasn't insert"
		log.Error(message)
		response.Message = message
		response.Status = "Error"
		return &response
	}

	//response.training = append(response.training, training)
	response.Status = "OK"
	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
Function to get the Training from TrainingRQ by Id
*/
func GetTraining(pRequest *DOMAIN.TrainingRQ) *DOMAIN.TrainingRS {
	timeResponse := time.Now()
	response := DOMAIN.TrainingRS{}

	log.Debug("GetTraining by ID", pRequest.ID)
	training := dao.GetTrainingById(pRequest.ID)
	if training != nil {
		response.Training = training
		log.Debug("Training result:", *training)
		//Search all training skills
		trainingSkills := dao.GetTrainingSkillsByTrainingId(training.ID)
		log.Debug("TrainingSkills result:", len(trainingSkills))
		response.TrainingSkills = trainingSkills
	} else {
		log.Debug("Training result empty", pRequest.ID)
	}

	//response.training = append(response.training, training)
	response.Status = "OK"
	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}
