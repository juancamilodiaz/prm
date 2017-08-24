package tool

import (
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/util"
)

func CreateResource(pRequest *domain.CreateResourceRQ) *domain.CreateResourceRS {
	resource := util.MappingCreateResource(pRequest)
	id := util.GenerateID(resource)
	resource.ID = id
	// TODO Save in DB
	response := domain.CreateResourceRS{}
	return &response
}

func UpdateResource(pResource *domain.UpdateResourceRQ) *domain.UpdateResourceRS {
	response := domain.UpdateResourceRS{}
	oldResource := GetResource(pResource.ID)
	if oldResource != nil {
		oldResource.Name = pResource.Name
		oldResource.LastName = pResource.LastName
		oldResource.Email = pResource.Email
		oldResource.Level = pResource.Level
		oldResource.Photo = pResource.Photo
		oldResource.Enable = pResource.Enable
		// TODO Save in DB
	}
	return &response
}

func DeleteResource(pResource *domain.DeleteResourceRQ) *domain.DeleteResourceRS {
	response := domain.DeleteResourceRS{}
	// TODO Delete in DB
	return &response
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
