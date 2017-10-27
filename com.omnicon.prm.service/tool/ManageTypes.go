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
		if pRequest.TypeOf != "" {
			oldType.TypeOf = pRequest.TypeOf
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

		// Update table with new name
		if pRequest.TypeOf == "resource" {
			resourcesTypes := dao.GetResourceTypesByTypeId(pRequest.ID)
			for _, resourceType := range resourcesTypes {
				resourceType.Name = oldType.Name
				dao.UpdateResourceType(resourceType)
			}
		} else {
			projectsTypes := dao.GetProjectTypesByTypeId(pRequest.ID)
			for _, projectType := range projectsTypes {
				projectType.Name = oldType.Name
				dao.UpdateProjectType(projectType)
			}
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
		projectsType := dao.GetProjectTypesByTypeId(pRequest.ID)
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

	// Create response
	response := DOMAIN.ProjectTypesRS{}

	existTypeInProject := dao.GetProjectTypesByProjectIdAndTypeId(pRequest.ProjectId, pRequest.TypeId)
	if existTypeInProject != nil {
		message := "The type already exists for the project."
		log.Error(message)
		response.Message = message
		response.Status = "Error"
		return &response
	}

	request := new(DOMAIN.ProjectTypes)
	request.ProjectId = pRequest.ProjectId
	request.TypeId = pRequest.TypeId

	typeValue := dao.GetTypesById(pRequest.TypeId)
	if typeValue != nil {
		request.Name = typeValue.Name
	}

	id, err := dao.AddTypeToProject(request)

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

func GetTypeById(pRequest *DOMAIN.TypeRQ) *DOMAIN.TypeRS {
	timeResponse := time.Now()
	response := DOMAIN.TypeRS{}

	types := dao.GetTypesById(pRequest.ID)

	if types != nil {
		// Create response
		response.Status = "OK"
		response.Types = append(response.Types, types)

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Resources wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "OK"
	response.Header = util.BuildHeaderResponse(timeResponse)

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

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Resources wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "OK"

	response.Header = util.BuildHeaderResponse(timeResponse)

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

func DeleteTypesByProject(pRequest *DOMAIN.ProjectTypesRQ) *DOMAIN.ProjectTypesRS {
	timeResponse := time.Now()
	response := DOMAIN.ProjectTypesRS{}

	projectTypes := dao.GetProjectTypesByProjectIdAndTypeId(pRequest.ProjectId, pRequest.TypeId)

	if projectTypes != nil {

		rowsDeleted, err := dao.DeleteProjectTypes(projectTypes.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "ProjectTypes wasn't delete"
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

	message := "ProjectTypes wasn't found in DB"
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

func GetTypesByResource(pRequest *DOMAIN.GetResourcesRQ) *DOMAIN.ResourceTypesRS {
	timeResponse := time.Now()
	response := DOMAIN.ResourceTypesRS{}

	types := dao.GetAllTypes()
	response.Types = types

	resourceTypes := dao.GetResourceTypesByResourceId(pRequest.ID)

	if resourceTypes != nil {

		if len(resourceTypes) <= 0 {
			message := "Types to resources wasn't found in DB"
			log.Warn(message)
			response.Message = message
			response.Status = "Warning"
			response.Header = util.BuildHeaderResponse(timeResponse)
		}
		// Create response
		response.Status = "OK"
		response.ResourceTypes = resourceTypes
		response.Header = util.BuildHeaderResponse(timeResponse)
		return &response
	}

	message := "Types to resources wasn't found in DB"
	log.Warn(message)
	response.Message = message
	response.Status = "Error"
	response.Header = util.BuildHeaderResponse(timeResponse)
	return &response

}

func SetTypesByResource(pRequest *DOMAIN.ResourceTypesRQ) *DOMAIN.ResourceTypesRS {
	timeResponse := time.Now()

	// Create response
	response := DOMAIN.ResourceTypesRS{}

	existTypeInResource := dao.GetResourceTypesByResourceIdAndTypeId(pRequest.ResourceId, pRequest.TypeId)
	if existTypeInResource != nil {
		message := "The type already exists for the resource."
		log.Error(message)
		response.Message = message
		response.Status = "Error"
		return &response
	}

	request := new(DOMAIN.ResourceTypes)
	request.ResourceId = pRequest.ResourceId
	request.TypeId = pRequest.TypeId

	typeValue := dao.GetTypesById(pRequest.TypeId)
	if typeValue != nil {
		request.Name = typeValue.Name
	}

	id, err := dao.AddTypeToResource(request)

	response.Header = util.BuildHeaderResponse(timeResponse)
	if err != nil {
		message := "ResourceType wasn't insert"
		log.Error(message)
		response.Message = message
		response.Status = "Error"
		return &response
	}
	// Get ResourceType inserted
	resourceTypes := dao.GetResourceTypesById(id)
	response.ResourceTypes = append(response.ResourceTypes, resourceTypes)
	response.Status = "OK"

	return &response

}

func DeleteTypesByResource(pRequest *DOMAIN.ResourceTypesRQ) *DOMAIN.ResourceTypesRS {
	timeResponse := time.Now()
	response := DOMAIN.ResourceTypesRS{}

	resourceTypes := dao.GetResourceTypesByResourceIdAndTypeId(pRequest.ResourceId, pRequest.TypeId)

	if resourceTypes != nil {

		rowsDeleted, err := dao.DeleteResourceTypes(resourceTypes.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "ResourceTypes wasn't delete"
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

	message := "ResourceTypes wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"
	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}
