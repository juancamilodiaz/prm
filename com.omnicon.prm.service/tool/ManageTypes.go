package tool

import (
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

/**
* Function to create a new type from TypeRQ
 */
func CreateType(pRequest *DOMAIN.TypeRQ) *DOMAIN.TypeRS {
	timeResponse := time.Now()
	types := util.MappingType(pRequest)
	id, err := dao.AddType(types)
	// Create response
	response := DOMAIN.TypeRS{}
	if err != nil {
		message := "Skill wasn't insert"
		log.Error(message)
		response.Message = message
		response.Types = nil
		response.Status = "Error"
		return &response
	}
	// Get Skill inserted
	types = dao.GetTypesById(id)
	response.Types = append(response.Types, types)
	response.Status = "OK"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to update a type from UpdateSkillRQ
 */
func UpdateType(pRequest *DOMAIN.TypeRQ) *DOMAIN.TypeRS {
	timeResponse := time.Now()
	response := DOMAIN.TypeRS{}
	oldType := dao.GetTypesById(pRequest.ID)
	if oldType != nil {
		if pRequest.Name != "" {
			oldType.Name = pRequest.Name
		}
		// Save in DB
		rowsUpdated, err := dao.UpdateType(oldType)
		if err != nil || rowsUpdated <= 0 {
			message := "Type wasn't update"
			log.Error(message)
			response.Message = message
			response.Types = nil
			response.Status = "Error"
			return &response
		}
		// Get Type updated
		types := dao.GetTypesById(pRequest.ID)
		response.Types = append(response.Types, types)
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Type wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Types = nil
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to delete a Type from DeleteSkillRQ
 */
func DeleteType(pRequest *DOMAIN.TypeRQ) *DOMAIN.TypeRS {
	timeResponse := time.Now()
	response := DOMAIN.TypeRS{}
	typeToDelete := dao.GetTypesById(pRequest.ID)
	if typeToDelete != nil {

		//TODO Delete Types associations
		/*resourcesSkill := dao.GetProjectTypesByTypeId(pRequest.ID)
		for _, skill := range resourcesSkill {
			_, err := dao.DeleteResourceSkillsByResourceIdAndSkillId(skill.ResourceId, skill.SkillId)
			if err != nil {
				log.Error("Failed to delete skill resource")
			}
		}*/

		// Delete in DB
		rowsDeleted, err := dao.DeleteType(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "Type wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}
	message := "Type wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}
