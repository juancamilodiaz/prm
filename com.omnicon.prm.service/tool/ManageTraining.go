package tool

import (
	"strconv"
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
Function to get the Training Resources from TrainingResourcesRQ
*/
func GetTrainingResources(pRequest *DOMAIN.TrainingResourcesRQ) *DOMAIN.TrainingResourcesRS {
	timeResponse := time.Now()
	response := DOMAIN.TrainingResourcesRS{}

	log.Debugf("GetTrainingResource %+v \n", *pRequest)

	// Get trainings from TypeID input or all training
	trainings := []*DOMAIN.Training{}
	if pRequest.TypeID != 0 {
		trainings = dao.GetTrainingByTypeId(pRequest.TypeID)
	} else {
		trainings = dao.GetAllTraining()
	}

	if len(trainings) > 0 {

		response.FilteredTrainings = trainings

		// Get trainingResources from ResourceID input or all trainingResources
		trainingResourcesBreakdown := make(map[int]*DOMAIN.TrainingBreakdown)
		for _, training := range trainings {

			//Search all training resources
			trainingResources := []*DOMAIN.TrainingResources{}
			trainingsResources := dao.GetTrainingResourcesByTrainingId(training.ID)
			for _, trainingResource := range trainingsResources {
				trainingResource.TrainingName = training.Name
				if pRequest.ResourceId != 0 {
					if pRequest.ResourceId == trainingResource.ResourceId {
						resource := dao.GetResourceById(trainingResource.ResourceId)
						if resource != nil {
							trainingResource.ResourceName = resource.Name + " " + resource.LastName
						}
						trainingResources = append(trainingResources, trainingResource)
					}
				} else {
					resource := dao.GetResourceById(trainingResource.ResourceId)
					if resource != nil {
						trainingResource.ResourceName = resource.Name + " " + resource.LastName
					}
					trainingResources = append(trainingResources, trainingResource)
				}
			}

			// if exist element, fill the element and initialize the struct
			if len(trainingResources) > 0 {
				if trainingResourcesBreakdown[training.SkillId] == nil {
					trainingResourceDetail := new(DOMAIN.TrainingBreakdown)
					// get name from skill
					skill := dao.GetSkillById(training.SkillId)
					if skill != nil {
						trainingResourceDetail.SkillName = skill.Name
					}
					// get name from type
					_type := dao.GetTypesById(training.TypeId)
					if _type != nil {
						trainingResourceDetail.TypeName = _type.Name
					}
					trainingResourcesBreakdown[training.SkillId] = trainingResourceDetail
				}

				trainingResourcesBreakdown[training.SkillId].TrainingResources = append(trainingResourcesBreakdown[training.SkillId].TrainingResources, trainingResources...)
			}
		}

		// Calculate header elements
		for _, trainingResourceBD := range trainingResourcesBreakdown {
			var startDate, endDate time.Time
			var progess, testResult int
			for index, trainingResource := range trainingResourceBD.TrainingResources {
				if index == 0 {
					startDate = trainingResource.StartDate
					endDate = trainingResource.EndDate
				}
				if trainingResource.StartDate.Unix() < startDate.Unix() {
					startDate = trainingResource.StartDate
				}
				if trainingResource.EndDate.Unix() > endDate.Unix() {
					endDate = trainingResource.EndDate
				}
				progess += trainingResource.Progress
				testResult += trainingResource.TestResult
			}
			duration := endDate.Sub(startDate)

			trainingResourceBD.StartDate = startDate
			trainingResourceBD.EndDate = endDate
			trainingResourceBD.Duration = int(duration.Hours() / 24)
			trainingResourceBD.Progress = progess / len(trainingResourceBD.TrainingResources)
			trainingResourceBD.TestResult = testResult / len(trainingResourceBD.TrainingResources)
		}

		response.TrainingResources = trainingResourcesBreakdown

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
		log.Debug("Training resource result empty")
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

func SetTrainingToResource(pRequest *DOMAIN.TrainingResourcesRQ) *DOMAIN.TrainingResourcesRS {
	timeResponse := time.Now()
	response := DOMAIN.TrainingResourcesRS{}

	if pRequest.Progress < 0 || pRequest.Progress > 100 || pRequest.TestResult < 0 || pRequest.TestResult > 100 {
		message := "Set the percentage between 0 and 100"
		log.Error(message)
		response.Message = message
		response.Status = "Error"
		return &response
	}

	isValid, message := util.ValidateDates(&pRequest.StartDate, &pRequest.EndDate, false)
	if !isValid {
		response.Message = message
		response.Status = "Error"
		return &response
	}

	// Values for update
	var trainingResourceExist *DOMAIN.TrainingResources
	if pRequest.ID != 0 {
		trainingResourceExist = dao.GetTrainingResourcesById(pRequest.ID)
		if trainingResourceExist != nil {
			pRequest.ResourceId = trainingResourceExist.ResourceId
			pRequest.TrainingId = trainingResourceExist.TrainingId
		}
	}

	resource := dao.GetResourceById(pRequest.ResourceId)
	if resource != nil {
		// Get training in DB
		training := dao.GetTrainingById(pRequest.TrainingId)

		if training != nil {
			trainingResource := DOMAIN.TrainingResources{}

			trainingResource.ResourceId = pRequest.ResourceId
			trainingResource.TrainingId = pRequest.TrainingId
			startDate, err1 := time.Parse(util.DATEFORMAT, pRequest.StartDate)
			endDate, err2 := time.Parse(util.DATEFORMAT, pRequest.EndDate)
			if err1 != nil || err2 != nil {
				message := "Invalid Date"
				log.Error(message)
				response.Message = message
				response.Status = "Error"
				return &response
			}

			maxHours := 0
			for day := startDate; day.Unix() <= endDate.Unix(); day = day.AddDate(0, 0, 1) {
				if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
					maxHours += HoursOfWork
				}
			}
			if pRequest.Duration > maxHours {
				message := "Maximum hours of training " + strconv.Itoa(maxHours)
				log.Error(message)
				response.Message = message
				response.Status = "Error"
				return &response
			}

			trainingResource.StartDate = startDate
			trainingResource.EndDate = endDate
			trainingResource.Duration = pRequest.Duration
			trainingResource.Progress = pRequest.Progress
			trainingResource.TestResult = pRequest.TestResult

			if pRequest.Progress < 100 {
				pRequest.ResultStatus = "Pending"
			} else if pRequest.Progress == 100 {
				if pRequest.TestResult >= 70 {
					pRequest.ResultStatus = "Passed"
				} else {
					pRequest.ResultStatus = "Failed"
				}
			}
			trainingResource.ResultStatus = pRequest.ResultStatus

			// trainingResourceExist := dao.GetTrainingResourcesByResourceIdAndTrainingId(pRequest.ResourceId, pRequest.TrainingId)
			if trainingResourceExist != nil {

				if pRequest.ID == 0 {
					message := "The resource is already assigned to the training."
					log.Error(message)
					response.Message = message
					response.Status = "Error"
					return &response
				}

				trainingResourceExist.StartDate = startDate
				trainingResourceExist.EndDate = endDate
				trainingResourceExist.Duration = pRequest.Duration
				trainingResourceExist.Progress = pRequest.Progress
				trainingResourceExist.TestResult = pRequest.TestResult
				trainingResourceExist.ResultStatus = pRequest.ResultStatus
				// Call update trainingResource operation
				rowsUpdated, err := dao.UpdateTrainingResources(trainingResourceExist)
				if err != nil || rowsUpdated <= 0 {
					message := "No Set Training To Resource"
					log.Error(message)
					response.Message = message
					response.Status = "Error"
					return &response
				}
				// Get ResourceSkill inserted
				resourceSkillUpdated := dao.GetTrainingResourcesById(trainingResourceExist.ID)
				if resourceSkillUpdated != nil {

					response.Header = util.BuildHeaderResponse(timeResponse)

					response.Status = "OK"

					return &response
				}
			} else {
				id, err := dao.AddTrainingResources(&trainingResource)
				if err != nil {
					message := "No Set Training To Resource"
					log.Error(message)
					response.Message = message
					response.Status = "Error"
					return &response
				}
				// Get ResourceSkill inserted
				resourceSkillInserted := dao.GetTrainingResourcesById(id)
				if resourceSkillInserted != nil {

					response.Header = util.BuildHeaderResponse(timeResponse)

					response.Status = "OK"

					return &response
				}
			}

		} else {
			message := "Training doesn't exist, plese create it"
			log.Error(message)
			response.Message = message

			response.Header = util.BuildHeaderResponse(timeResponse)
			response.Status = "Error"
			return &response
		}
	}
	message = "Resource doesn't exist, plese create it"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to delete a assignation training to resource from TrainingRQ
 */
func DeleteTrainingToResource(pRequest *DOMAIN.TrainingResourcesRQ) *DOMAIN.TrainingResourcesRS {
	timeResponse := time.Now()
	response := DOMAIN.TrainingResourcesRS{}
	trainingResourceToDelete := dao.GetTrainingResourcesById(pRequest.ID)
	if trainingResourceToDelete != nil {

		// Delete in DB
		rowsDeleted, err := dao.DeleteTrainingResources(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "Training Resource wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}
	message := "Training Resource wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}
