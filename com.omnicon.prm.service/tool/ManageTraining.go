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
	_, err := dao.AddTraining(training)
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
	/*/ Get Taining inserted
	//training = dao.GetTrainingsById(id)
	trainingResources := util.MappingTrainingResources(id, pRequest.TrainingResources)
	err = dao.AddBulkTrainingResources(trainingResources)
	if err != nil {
		message := "TainingSkills wasn't insert"
		log.Error(message)
		response.Message = message
		response.Status = "Error"
		return &response
	}*/

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
		trainingResources := dao.GetTrainingResourcesByTrainingId(training.ID)
		log.Debug("TrainingSkills result:", len(trainingResources))
		response.TrainingResources = trainingResources

		resources := dao.GetAllResources()
		response.Resources = resources

		types := dao.GetAllTypes()
		response.Types = types

		trainings := dao.GetAllTraining()
		response.Trainings = trainings

		typesSkills := []*DOMAIN.TypeSkills{}
		for _, typeE := range types {
			typesSkills = append(typesSkills, dao.GetTypesSkillsByTypeId(typeE.ID)...)
		}
		response.TypesSkills = typesSkills
	} else {
		log.Debug("Training result empty", pRequest.ID)
	}

	//response.training = append(response.training, training)
	response.Status = "OK"
	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/*
* Get all elements of training from the request values
 */
func GetTrainings(pRequest *DOMAIN.TrainingRQ) *DOMAIN.TrainingRS {
	timeResponse := time.Now()
	response := DOMAIN.TrainingRS{}
	filters := util.MappingFiltersTraining(pRequest)
	trainings, filterString := dao.GetTrainingsByFilters(filters)

	if len(trainings) == 0 && filterString == "" {
		trainings = dao.GetAllTraining()
	}

	// get all types
	types := dao.GetAllTypes()
	response.Types = types

	// get all skills
	skills := dao.GetAllSkills()
	response.Skills = skills

	// get the relation between types and skills
	typesSkills := dao.GetAllTypesSkills()
	response.TypesSkills = typesSkills

	if trainings != nil && len(trainings) > 0 {

		response.Trainings = trainings
		// Create response
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Trainings wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to update a training from TrainingRQ
 */
func UpdateTraining(pRequest *DOMAIN.TrainingRQ) *DOMAIN.TrainingRS {
	timeResponse := time.Now()
	response := DOMAIN.TrainingRS{}
	oldTraining := dao.GetTrainingById(pRequest.ID)
	if oldTraining != nil {
		if pRequest.Name != "" {
			oldTraining.Name = pRequest.Name
		}
		// Save in DB
		rowsUpdated, err := dao.UpdateTraining(oldTraining)
		if err != nil || rowsUpdated <= 0 {
			message := "Training wasn't update"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Training wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to delete a training from TrainingRQ
 */
func DeleteTraining(pRequest *DOMAIN.TrainingRQ) *DOMAIN.TrainingRS {
	timeResponse := time.Now()
	response := DOMAIN.TrainingRS{}
	trainingToDelete := dao.GetTrainingById(pRequest.ID)
	if trainingToDelete != nil {

		// Delete training associations
		trainingResource := dao.GetTrainingResourcesByTrainingId(pRequest.ID)
		for _, training := range trainingResource {
			_, err := dao.DeleteTrainingResourcesByTrainingId(training.TrainingId)
			if err != nil {
				log.Error("Failed to delete training resource")
			}
		}

		// Delete in DB
		rowsDeleted, err := dao.DeleteTraining(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "Training wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}
	message := "Training wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}
