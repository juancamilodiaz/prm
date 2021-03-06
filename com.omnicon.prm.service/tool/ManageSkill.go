package tool

import (
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

/**
* Function to create a new skill from CreateSkillRQ
 */
func CreateSkill(pRequest *DOMAIN.CreateSkillRQ) *DOMAIN.CreateSkillRS {
	timeResponse := time.Now()
	skill := util.MappingCreateSkill(pRequest)
	id, err := dao.AddSkill(skill)
	// Create response
	response := DOMAIN.CreateSkillRS{}
	if err != nil {
		message := "Skill wasn't insert"
		log.Error(message)
		response.Message = message
		response.Skill = nil
		response.Status = "Error"
		return &response
	}
	// Get Skill inserted
	skill = dao.GetSkillById(id)
	response.Skill = skill
	response.Status = "OK"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to update a skill from UpdateSkillRQ
 */
func UpdateSkill(pRequest *DOMAIN.UpdateSkillRQ) *DOMAIN.UpdateSkillRS {
	timeResponse := time.Now()
	response := DOMAIN.UpdateSkillRS{}
	oldSkill := dao.GetSkillById(pRequest.ID)
	if oldSkill != nil {
		if pRequest.Name != "" {
			oldSkill.Name = pRequest.Name
		}
		// Save in DB
		rowsUpdated, err := dao.UpdateSkill(oldSkill)
		if err != nil || rowsUpdated <= 0 {
			message := "Skill wasn't update"
			log.Error(message)
			response.Message = message
			response.Skill = nil
			response.Status = "Error"
			return &response
		}
		// Get Skill updated
		skill := dao.GetSkillById(pRequest.ID)
		response.Skill = skill
		response.Status = "OK"

		// Update relation tables.
		resourcesSkills := dao.GetResourceSkillsBySkillId(pRequest.ID)
		for _, resourceSkill := range resourcesSkills {
			resourceSkill.Name = oldSkill.Name
			dao.UpdateResourceSkills(resourceSkill)
		}
		typesSkills := dao.GetTypesSkillsBySkillId(pRequest.ID)
		for _, typeSkill := range typesSkills {
			typeSkill.Name = oldSkill.Name
			dao.UpdateTypeSkills(typeSkill)
		}

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Skill wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Skill = nil
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to delete a skill from DeleteSkillRQ
 */
func DeleteSkill(pRequest *DOMAIN.DeleteSkillRQ) *DOMAIN.DeleteSkillRS {
	timeResponse := time.Now()
	response := DOMAIN.DeleteSkillRS{}
	skillToDelete := dao.GetSkillById(pRequest.ID)
	if skillToDelete != nil {

		// Delete skills associations
		resourcesSkill := dao.GetResourceSkillsBySkillId(pRequest.ID)
		for _, skill := range resourcesSkill {
			_, err := dao.DeleteResourceSkillsByResourceIdAndSkillId(skill.ResourceId, skill.SkillId)
			if err != nil {
				log.Error("Failed to delete skill resource")
			}
		}

		// Delete skills associations
		typeSkill := dao.GetTypesSkillsBySkillId(int(pRequest.ID))
		for _, skill := range typeSkill {
			_, err := dao.DeleteTypeSkillsByTypeIdAndSkillId(skill.TypeId, skill.SkillId)
			if err != nil {
				log.Error("Failed to delete skill type")
			}
		}

		// Delete skills associations (training and training resouces)
		trainings := dao.GetTrainingBySkillId(int(pRequest.ID))
		for _, training := range trainings {
			// Delete training resource
			_, err := dao.DeleteTrainingResourcesByTrainingId(training.ID)
			if err != nil {
				log.Error("Failed to delete training resource")
			}
			_, err = dao.DeleteTraining(training.ID)
			if err != nil {
				log.Error("Failed to delete training")
			}
		}

		// Delete in DB
		rowsDeleted, err := dao.DeleteSkill(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "Skill wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.ID = skillToDelete.ID
		response.Name = skillToDelete.Name
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}
	message := "Skill wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func GetSkills(pRequest *DOMAIN.GetSkillsRQ) *DOMAIN.GetSkillsRS {
	timeResponse := time.Now()
	response := DOMAIN.GetSkillsRS{}
	filters := util.MappingFiltersSkill(pRequest)
	skills, filterString := dao.GetSkillsByFilters(filters)

	if len(skills) == 0 && filterString == "" {
		skills = dao.GetAllSkills()
	}

	if skills != nil && len(skills) > 0 {

		response.Skills = skills
		// Create response
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Skills wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func SetSkillsByType(pRequest *DOMAIN.TypeSkillsRQ) *DOMAIN.TypeSkillsRS {
	timeResponse := time.Now()

	// Create response
	response := DOMAIN.TypeSkillsRS{}

	if pRequest.Value < 1 || pRequest.Value > 100 {
		message := "Set the percentage between 1 and 100"
		log.Error(message)
		response.Message = message
		response.Skills = nil
		response.Status = "Error"
		return &response
	}

	skillType := dao.GetTypesSkillsByTypeIdAndSkillId(pRequest.TypeId, pRequest.SkillId)
	if skillType == nil {
		request := DOMAIN.TypeSkills{}
		request.SkillId = pRequest.SkillId
		request.TypeId = pRequest.TypeId
		request.Value = pRequest.Value
		request.Name = pRequest.Name

		id, err := dao.AddSkillToType(request)

		response.Header = util.BuildHeaderResponse(timeResponse)
		if err != nil {
			message := "Skill wasn't assigned"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}
		// Get Resource inserted
		typeSkills := dao.GetTypeSkillsById(id)
		response.TypeSkills = append(response.TypeSkills, typeSkills)
		response.Status = "OK"

		return &response

	} else {
		skillType.Name = pRequest.Name
		skillType.Value = pRequest.Value
		id, err := dao.UpdateTypeSkills(skillType)

		// Create response
		response := DOMAIN.TypeSkillsRS{}
		response.Header = util.BuildHeaderResponse(timeResponse)
		if err != nil {
			message := "Skill wasn't updated"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}
		// Get Resource inserted
		typeSkills := dao.GetTypeSkillsById(int(id))
		response.TypeSkills = append(response.TypeSkills, typeSkills)
		response.Status = "OK"

		return &response
	}
}
