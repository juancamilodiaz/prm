package tool

import (
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

/**
* Function to create a new resource from CreateResourceRQ
 */
func CreateResource(pRequest *DOMAIN.CreateResourceRQ) *DOMAIN.CreateResourceRS {
	timeResponse := time.Now()
	resource := util.MappingCreateResource(pRequest)
	id, err := dao.AddResource(resource)
	// Create response
	response := DOMAIN.CreateResourceRS{}
	if err != nil {
		message := "Resource wasn't insert"
		log.Error(message)
		response.Message = message
		response.Resource = nil
		response.Status = "Error"
		return &response
	}
	// Get Resource inserted
	resource = dao.GetResourceById(id)
	response.Resource = resource
	response.Status = "OK"

	header := new(DOMAIN.CreateResourceRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

/**
* Function to update a resource from UpdateResourceRQ
 */
func UpdateResource(pResource *DOMAIN.UpdateResourceRQ) *DOMAIN.UpdateResourceRS {
	timeResponse := time.Now()
	response := DOMAIN.UpdateResourceRS{}
	oldResource := dao.GetResourceById(pResource.ID)
	if oldResource != nil {
		if pResource.Name != "" {
			oldResource.Name = pResource.Name
		}
		if pResource.LastName != "" {
			oldResource.LastName = pResource.LastName
		}
		if pResource.Email != "" {
			oldResource.Email = pResource.Email
		}
		if pResource.EngineerRange != "" {
			oldResource.EngineerRange = pResource.EngineerRange
		}
		if pResource.Photo != "" {
			oldResource.Photo = pResource.Photo
		}
		oldResource.Enabled = pResource.Enabled
		// Save in DB
		rowsUpdated, err := dao.UpdateResource(oldResource)
		if err != nil || rowsUpdated <= 0 {
			message := "Resource wasn't update"
			log.Error(message)
			response.Message = message
			response.Resource = nil
			response.Status = "Error"
			return &response
		}
		// Get Resource updated
		resource := dao.GetResourceById(pResource.ID)
		response.Resource = resource
		response.Status = "OK"

		header := new(DOMAIN.UpdateResourceRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}

	message := "Resource wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Resource = nil
	response.Status = "Error"

	header := new(DOMAIN.UpdateResourceRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

/**
* Function to delete a resource from DeleteResourceRQ
 */
func DeleteResource(pResource *DOMAIN.DeleteResourceRQ) *DOMAIN.DeleteResourceRS {
	timeResponse := time.Now()
	response := DOMAIN.DeleteResourceRS{}
	resourceToDelete := dao.GetResourceById(pResource.ID)
	if resourceToDelete != nil {
		// Delete in DB
		rowsDeleted, err := dao.DeleteResource(pResource.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "Resource wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.ID = resourceToDelete.ID
		response.Name = resourceToDelete.Name
		response.LastName = resourceToDelete.LastName
		response.Status = "OK"

		header := new(DOMAIN.DeleteResourceRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}
	message := "Resource wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	header := new(DOMAIN.DeleteResourceRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func DisableResource(pId string) bool {
	oldResource := GetResource(pId)
	if oldResource != nil {
		oldResource.Enabled = false
		// TODO Save in DB
		return true
	}
	return false
}

func EnableResource(pId string) bool {
	oldResource := GetResource(pId)
	if oldResource != nil {
		oldResource.Enabled = true
		// TODO Save in DB
		return true
	}
	return false
}

func GetResource(pId string) *DOMAIN.Resource {
	resource := DOMAIN.Resource{}
	// TODO Get from DB
	return &resource
}

func ValidateRQ(pResource *DOMAIN.Resource) bool {
	// TODO Validations here
	return true
}

func SetSkillToResource(pRequest *DOMAIN.SetSkillToResourceRQ) *DOMAIN.SetSkillToResourceRS {
	timeResponse := time.Now()
	response := DOMAIN.SetSkillToResourceRS{}
	resource := dao.GetResourceById(pRequest.ResourceId)
	if resource != nil {
		// Get Skill in DB
		skill := dao.GetSkillById(pRequest.SkillId)
		if skill != nil {
			resourceSkill := DOMAIN.ResourceSkills{}
			resourceSkill.ResourceId = pRequest.ResourceId
			resourceSkill.SkillId = pRequest.SkillId
			resourceSkill.Name = skill.Name
			resourceSkill.Value = pRequest.Value

			resourceSkillExist := dao.GetResourceSkillsByResourceIdAndSkillId(pRequest.ResourceId, pRequest.SkillId)
			if resourceSkillExist != nil {
				resourceSkillExist.Value = pRequest.Value
				// Call update resourceSkill operation
				rowsUpdated, err := dao.UpdateResourceSkills(resourceSkillExist)
				if err != nil || rowsUpdated <= 0 {
					message := "No Set Skill To Resource"
					log.Error(message)
					response.Message = message
					response.Resource = nil
					response.Status = "Error"
					return &response
				}
				// Get ResourceSkill inserted
				resourceSkillUpdated := dao.GetResourceSkillsById(resourceSkillExist.ID)
				if resourceSkillUpdated != nil {
					response.Resource = dao.GetResourceById(pRequest.ResourceId)
					// Get all skills to this resource
					skillsOfResource := dao.GetResourceSkillsByResourceId(pRequest.ResourceId)
					// Mapping skills in the resource of the response
					util.MappingSkillsInAResource(response.Resource, skillsOfResource)

					header := new(DOMAIN.SetSkillToResourceRS_Header)
					header.RequestDate = time.Now().String()
					responseTime := time.Now().Sub(timeResponse)
					header.ResponseTime = responseTime.String()
					response.Header = header

					response.Status = "OK"

					return &response
				}
			} else {
				id, err := dao.AddResourceSkills(&resourceSkill)
				if err != nil {
					message := "No Set Skill To Resource"
					log.Error(message)
					response.Message = message
					response.Resource = nil
					response.Status = "Error"
					return &response
				}
				// Get ResourceSkill inserted
				resourceSkillInserted := dao.GetResourceSkillsById(id)
				if resourceSkillInserted != nil {
					response.Resource = dao.GetResourceById(pRequest.ResourceId)
					// Get all skills to this resource
					skillsOfResource := dao.GetResourceSkillsByResourceId(pRequest.ResourceId)
					// Mapping skills in the resource of the response
					util.MappingSkillsInAResource(response.Resource, skillsOfResource)

					header := new(DOMAIN.SetSkillToResourceRS_Header)
					header.RequestDate = time.Now().String()
					responseTime := time.Now().Sub(timeResponse)
					header.ResponseTime = responseTime.String()
					response.Header = header

					response.Status = "OK"

					return &response
				}
			}

		} else {
			message := "Skill doesn't exist, plese create it"
			log.Error(message)
			response.Message = message
			header := new(DOMAIN.SetSkillToResourceRS_Header)
			header.RequestDate = time.Now().String()
			responseTime := time.Now().Sub(timeResponse)
			header.ResponseTime = responseTime.String()
			response.Header = header
			response.Status = "Error"
			return &response
		}
	}
	message := "Resource doesn't exist, plese create it"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	header := new(DOMAIN.SetSkillToResourceRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func DeleteSkillToResource(pRequest *DOMAIN.DeleteSkillToResourceRQ) *DOMAIN.DeleteSkillToResourceRS {
	timeResponse := time.Now()
	response := DOMAIN.DeleteSkillToResourceRS{}
	resourceSkill := dao.GetResourceSkillsByResourceIdAndSkillId(pRequest.ResourceId, pRequest.SkillId)
	if resourceSkill != nil {
		// Delete in DB
		rowsDeleted, err := dao.DeleteResourceSkillsByResourceIdAndSkillId(pRequest.ResourceId, pRequest.SkillId)
		if err != nil || rowsDeleted <= 0 {
			message := "ResourceSkill wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.ID = resourceSkill.ID
		resource := dao.GetResourceById(resourceSkill.ResourceId)
		response.ResourceName = resource.Name
		response.SkillName = resourceSkill.Name
		response.Status = "OK"

		header := new(DOMAIN.DeleteSkillToResourceRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}
	message := "ResourceSkill wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	header := new(DOMAIN.DeleteSkillToResourceRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func GetResources(pRequest *DOMAIN.GetResourcesRQ) *DOMAIN.GetResourcesRS {
	timeResponse := time.Now()
	response := DOMAIN.GetResourcesRS{}
	filters := util.MappingFiltersResource(pRequest)
	resources, filterString := dao.GetResourcesByFilters(filters, pRequest.Enabled)

	//	var resultResources []*DOMAIN.Resource

	if len(resources) == 0 && filterString == "" {
		resources = dao.GetAllResources()
	}

	if resources != nil && len(resources) > 0 {

		/*
			// Filter by skills
			if len(filters.Skills) > 0 {
				for _, resource := range resources {
					idResource := resource.ID
					var resultSkills []*DOMAIN.ResourceSkills
					for nameSkill, valueSkill := range filters.Skills {
						skills := dao.GetSkillsByName(nameSkill)
						for _, skill := range skills {
							if skill.Name == nameSkill {
								resourceSkill := dao.GetResourceSkillsByResourceIdAndSkillId(idResource, skill.ID)
								if resourceSkill != nil && resourceSkill.Value >= valueSkill {
									resultSkills = append(resultSkills, resourceSkill)
								}
							}
						}
					}
					if len(resultSkills) > 0 {
						util.MappingSkillsInAResource(resource, resultSkills)
						resultResources = append(resultResources, resource)
					}
				}
				response.Resources = resultResources
			} else {
				for _, resource := range resources {
					resourceSkill := dao.GetResourceSkillsByResourceId(resource.ID)
					if len(resourceSkill) > 0 {
						util.MappingSkillsInAResource(resource, resourceSkill)
					}
				}
				response.Resources = resources
			}
		*/

		// Create response
		response.Status = "OK"
		response.Resources = resources

		header := new(DOMAIN.GetResourcesRS_Header)
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

	header := new(DOMAIN.GetResourcesRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}
