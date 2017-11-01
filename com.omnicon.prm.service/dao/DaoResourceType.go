package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getResourceTypesCollection
*	Return: db.Collection
*	Description: Get table ResourceType in a session
 */
func getResourceTypesCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("ResourceTypes")
}

/**
*	Name : GetAllResourceTypes
*	Return: []*DOMAIN.ResourceTypes
*	Description: Get all resources and skills in a ResourceTypes table
 */
func GetAllResourceTypes() []*DOMAIN.ResourceTypes {
	// Slice to keep all ProjectTypes
	var ResourceTypes []*DOMAIN.ResourceTypes
	// Add all ResourceTypes in resources variable
	err := getResourceTypesCollection().Find().All(ResourceTypes)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return ResourceTypes
}

/**
*	Name : GetResourceTypesById
*	Params: pId
*	Return: *DOMAIN.ResourceTypes
*	Description: Get a resourceTypes by ID in a ResourceTypes table
 */
func GetResourceTypesById(pId int) *DOMAIN.ResourceTypes {
	// ResourceTypes structure
	ResourceTypes := DOMAIN.ResourceTypes{}
	// Add in ResourceTypes variable, the ResourceTypes where ID is the same that the param
	res := getResourceTypesCollection().Find(db.Cond{"id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&ResourceTypes)
	if err != nil {
		log.Error(err)
	}
	return &ResourceTypes
}

/**
*	Name : GetResourceTypesByResourceId
*	Params: pId
*	Return: *DOMAIN.ResourceTypes
*	Description: Get a resourceType by ResourceId in a ResourceTypes table
 */
func GetResourceTypesByResourceId(pResourceId int) []*DOMAIN.ResourceTypes {
	// Slice to keep all ResourceTypes
	var resourceTypes []*DOMAIN.ResourceTypes
	// Add all ResourceTypes in ResourceTypes variable
	err := getResourceTypesCollection().Find(db.Cond{"resource_id": pResourceId}).All(&resourceTypes)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return resourceTypes
}

/**
*	Name : GetResourceTypesBySkillId
*	Params: pId
*	Return: *DOMAIN.ResourceTypes
*	Description: Get a resourceType by TypeId in a ResourceTypes table
 */
func GetResourceTypesByTypeId(pId int) []*DOMAIN.ResourceTypes {
	// Slice to keep all ResourceTypes
	var ResourceTypes []*DOMAIN.ResourceTypes
	// Add all ResourceTypes in ResourceTypes variable
	err := getResourceTypesCollection().Find(db.Cond{"type_id": pId}).All(&ResourceTypes)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return ResourceTypes
}

/**
*	Name : GetResourceTypesByResourceIdAndTypeId
*	Params: pResourceId, pTypeId
*	Return: *DOMAIN.ResourceTypes
*	Description: Get a resourceType by ResourceId and TypeId in a ResourceTypes table
 */
func GetResourceTypesByResourceIdAndTypeId(pResourceId, pTypeId int) *DOMAIN.ResourceTypes {
	// keep  ResourceTypes
	var resourceTypes *DOMAIN.ResourceTypes
	// Add all ResourceTypes in ResourceTypes variable
	res := getResourceTypesCollection().Find(db.Cond{"resource_id": pResourceId}).And(db.Cond{"type_id": pTypeId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&resourceTypes)
	if err != nil {
		log.Error(err)
	}
	return resourceTypes
}

/**
*	Name : AddResourceTypes
*	Params: pResourceTypes
*	Return: int, error
*	Description: Add ResourceTypes in DB
 */
func AddTypeToResource(pResourceTypes *DOMAIN.ResourceTypes) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	res, err := session.InsertInto("ResourceTypes").Columns(
		"resource_id",
		"type_id",
		"type_name").Values(
		pResourceTypes.ResourceId,
		pResourceTypes.TypeId,
		pResourceTypes.Name).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return int(insertId), nil
}

/**
*	Name : DeleteResourceTypes
*	Params: pResourceTypesId
*	Return: int, error
*	Description: Delete ResourceTypes in DB
 */
func DeleteResourceTypes(pResourceTypesId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete ResourceTypes in DB
	q := session.DeleteFrom("ResourceTypes").Where("id", int(pResourceTypesId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}

/**
*	Name : DeleteResourceTypesByResourceIdAndTypeId
*	Params: pResourceId, pTypeId
*	Return: int, error
*	Description: Delete ResourceTypes in DB
 */
func DeleteResourceTypesByResourceIdAndTypeId(pResourceId, pTypeId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete ResourceTypes in DB
	q := session.DeleteFrom("ResourceTypes").Where("resource_id", pResourceId).And("type_id", pTypeId)
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}

/**
*	Name : UpdateResourceType
*	Params: pResourceTypes
*	Return: int, error
*	Description: Update ResourceTypes in DB
 */
func UpdateResourceType(pResourceTypes *DOMAIN.ResourceTypes) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update ResourceTypes in DB
	q := session.Update("ResourceTypes").Set("type_name = ?", pResourceTypes.Name).Where("id = ?", pResourceTypes.ID)
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows updated
	updateCount, err := res.RowsAffected()
	return int(updateCount), nil
}
