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
