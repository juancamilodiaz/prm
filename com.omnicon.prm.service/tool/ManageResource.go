package tool

import (
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.utilities/utils"
)

func CreateResource(pRequest *domain.CreateResourceRQ) *domain.CreateResourceRS {
	resource := utils.MappingCreateResource(pRequest)
	id := utils.GenerateID(resource)
	resource.ID = id
	// TODO Save in DB
	response := domain.CreateResourceRS{}
	return &response
}

func UpdateResource(pResource *domain.Resource) bool {
	oldResource := GetResource(pResource.ID)
	if oldResource != nil {
		oldResource.Name = pResource.Name
		oldResource.LastName = pResource.LastName
		oldResource.Email = pResource.Email
		oldResource.Level = pResource.Level
		oldResource.Photo = pResource.Photo
		oldResource.Enable = pResource.Enable
		// TODO Save in DB
		return true
	}
	return false
}

func DeleteResource(pResource *domain.Resource) bool {
	// TODO Delete in DB
	return true
}

func DisableResource(pId string) bool {
	oldResource := GetResource(pId)
	if oldResource != nil {
		oldResource.Enable = false
		// TODO Save in DB
		return true
	}
	return false
}

func EnableResource(pId string) bool {
	oldResource := GetResource(pId)
	if oldResource != nil {
		oldResource.Enable = true
		// TODO Save in DB
		return true
	}
	return false
}

func GetResource(pId string) *domain.Resource {
	resource := domain.Resource{}
	// TODO Get from DB
	return &resource
}

func ValidateRQ(pResource *domain.Resource) bool {
	// TODO Validations here
	return true
}
