package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getProjectCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getResourceCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("Resource")
}

/**
*	Name : GetAllResources
*	Return: []*DOMAIN.Resource
*	Description: Get all resources in a resource table
 */
func GetAllResources() []*DOMAIN.Resource {
	// Slice to keep all resources
	var resources []*DOMAIN.Resource
	// Add all resources in resources variable
	err := getResourceCollection().Find().All(resources)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return resources
}

/**
*	Name : GetResourceById
*	Params: pId
*	Return: *DOMAIN.Resource
*	Description: Get a resource by ID in a resource table
 */
func GetResourceById(pId int64) *DOMAIN.Resource {
	// Resource structure
	resource := DOMAIN.Resource{}
	// Add in resource variable, the resource where ID is the same that the param
	res := getResourceCollection().Find(db.Cond{"id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&resource)
	if err != nil {
		log.Error(err)
	}
	return &resource
}

/**
*	Name : GetResourcesByName
*	Params: pName
*	Return: []*DOMAIN.Resource
*	Description: Get a slice of resource with a name in a resource table
 */
func GetResourcesByName(pName string) []*DOMAIN.Resource {
	// Slice to keep all resources
	resources := []*DOMAIN.Resource{}
	// Filter resources by name
	res := getResourceCollection().Find().Where("name = ?", pName)
	// Close session when ends the method
	defer session.Close()
	// Add all resources in resources variable
	err := res.All(&resources)
	if err != nil {
		log.Error(err)
	}
	return resources
}

/**
*	Name : AddResource
*	Params: pResource
*	Return: int, error
*	Description: Add resource in DB
 */
func AddResource(pResource *DOMAIN.Resource) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	res, err := session.InsertInto("Resource").Columns(
		"name",
		"last_name",
		"email",
		"photo",
		"engineer_range",
		"enabled").Values(
		pResource.Name,
		pResource.LastName,
		pResource.Email,
		pResource.Photo,
		pResource.EngineerRange,
		pResource.Enabled).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return insertId, nil
}

/**
*	Name : UpdateResource
*	Params: pResource
*	Return: int, error
*	Description: Update resource in DB
 */
func UpdateResource(pResource *DOMAIN.Resource) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update resource in DB
	q := session.Update("Resource").Set("name = ?, last_name = ?, email = ?, photo = ?, engineer_range = ?, enabled = ?", pResource.Name, pResource.LastName, pResource.Email, pResource.Photo, pResource.EngineerRange, pResource.Enabled).Where("id = ?", int(pResource.ID))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows updated
	updateCount, err := res.RowsAffected()
	return updateCount, nil
}

/**
*	Name : DeleteResource
*	Params: pResourceId
*	Return: int, error
*	Description: Delete resource in DB
 */
func DeleteResource(pResourceId int64) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete resource in DB
	q := session.DeleteFrom("Resource").Where("id", int(pResourceId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return deleteCount, nil
}
