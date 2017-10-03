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

		// Delete asignation to project
		projectsType := dao.GetProjectTypesByTypeId(int64(pRequest.ID))
		for _, project := range projectsType {
			_, err := dao.DeleteProjectTypesByProjectIdAndTypeId(int(project.ProjectId), project.TypeId)
			if err != nil {
				log.Error("Failed to delete project resource")
			}
		}

		// Delete skills assignation to type
		skillsType := dao.GetTypesSkillsByTypeId(pRequest.ID)
		for _, skill := range skillsType {
			_, err := dao.DeleteTypeSkillsByTypeIdAndSkillId(skill.TypeId, skill.SkillId)
			if err != nil {
				log.Error("Failed to delete skill resource")
			}
		}

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

func SetTypesByProject(pRequest *DOMAIN.ProjectTypesRQ) *DOMAIN.ProjectTypesRS {
	timeResponse := time.Now()
	request := new(DOMAIN.ProjectTypes)
	request.ProjectId = int64(pRequest.ProjectId)
	request.TypeId = pRequest.TypeId

	typeValue := dao.GetTypesById(pRequest.TypeId)
	if typeValue != nil {
		request.Name = typeValue.Name
	}

	id, err := dao.AddTypeToProject(request)

	// Create response
	response := DOMAIN.ProjectTypesRS{}
	response.Header = util.BuildHeaderResponse(timeResponse)
	if err != nil {
		message := "ProjectType wasn't insert"
		log.Error(message)
		response.Message = message
		response.Status = "Error"
		return &response
	}
	// Get ProjectType inserted
	projectTypes := dao.GetProjectTypesById(id)
	response.ProjectTypes = append(response.ProjectTypes, projectTypes)
	response.Status = "OK"

	return &response

}

func GetTypes(pRequest *DOMAIN.TypeRQ) *DOMAIN.TypeRS {
	timeResponse := time.Now()
	response := DOMAIN.TypeRS{}

	types := dao.GetAllTypes()

	if types != nil && len(types) > 0 {
		// Create response
		response.Status = "OK"
		response.Types = types

		header := new(DOMAIN.Response_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}

	message := "Resources wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "OK"

	header := new(DOMAIN.Response_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func GetSkillsByType(pRequest *DOMAIN.TypeRQ) *DOMAIN.TypeSkillsRS {
	timeResponse := time.Now()
	response := DOMAIN.TypeSkillsRS{}

	response.Skills = dao.GetAllSkills()

	typeSkills := dao.GetTypesSkillsByTypeId(pRequest.ID)

	if typeSkills != nil && len(typeSkills) > 0 {
		// Create response
		response.Status = "OK"
		response.TypeSkills = typeSkills
		response.Header = util.BuildHeaderResponse(timeResponse)
		return &response
	}

	message := "Resources wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"
	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func GetTypesByProject(pRequest *DOMAIN.GetProjectsRQ) *DOMAIN.ProjectTypesRS {
	timeResponse := time.Now()
	response := DOMAIN.ProjectTypesRS{}

	types := dao.GetAllTypes()
	response.Types = types

	projectTypes := dao.GetProjectTypesByProjectId(pRequest.ID)

	if projectTypes != nil && len(projectTypes) > 0 {
		// Create response
		response.Status = "OK"
		response.ProjectTypes = projectTypes
		response.Header = util.BuildHeaderResponse(timeResponse)
		return &response
	}

	message := "Resources wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"
	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response

}

func DeleteSkillsByType(pRequest *DOMAIN.TypeSkillsRQ) *DOMAIN.TypeSkillsRS {
	timeResponse := time.Now()
	response := DOMAIN.TypeSkillsRS{}

	skillsTypes := dao.GetTypeSkillsById(pRequest.ID)

	if skillsTypes != nil {

		rowsDeleted, err := dao.DeleteTypeSkillsById(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "TypeSkills wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}
		// Create response
		response.Status = "OK"
		response.Header = util.BuildHeaderResponse(timeResponse)
		return &response
	}

	message := "TypeSkills wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"
	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}
