package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getProjectTypesCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getProjectTypesCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("ProjectTypes")
}

/**
*	Name : GetAllProjectTypes
*	Return: []*DOMAIN.ProjectTypes
*	Description: Get all resources and skills in a ProjectTypes table
 */
func GetAllProjectTypes() []*DOMAIN.ProjectTypes {
	// Slice to keep all ProjectTypes
	var ProjectTypes []*DOMAIN.ProjectTypes
	// Add all ProjectTypes in resources variable
	err := getProjectTypesCollection().Find().All(ProjectTypes)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return ProjectTypes
}

/**
*	Name : GetResourceSkillById
*	Params: pId
*	Return: *DOMAIN.ProjectTypes
*	Description: Get a resourceSkill by ID in a ProjectTypes table
 */
func GetProjectTypesById(pId int64) *DOMAIN.ProjectTypes {
	// ProjectTypes structure
	ProjectTypes := DOMAIN.ProjectTypes{}
	// Add in ProjectTypes variable, the ProjectTypes where ID is the same that the param
	res := getProjectTypesCollection().Find(db.Cond{"id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&ProjectTypes)
	if err != nil {
		log.Error(err)
	}
	return &ProjectTypes
}

/**
*	Name : GetProjectTypesByResourceId
*	Params: pId
*	Return: *DOMAIN.ProjectTypes
*	Description: Get a resourceSkill by ResourceId in a ProjectTypes table
 */
func GetTypesByProjectId(pProjectId int64) []*DOMAIN.ProjectTypes {
	// Slice to keep all ProjectTypes
	var projectTypes []*DOMAIN.ProjectTypes
	// Add all ProjectTypes in ProjectTypes variable
	err := getProjectTypesCollection().Find(db.Cond{"project_id": pProjectId}).All(&projectTypes)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return projectTypes
}

/**
*	Name : GetProjectTypesBySkillId
*	Params: pId
*	Return: *DOMAIN.ProjectTypes
*	Description: Get a resourceSkill by SkillId in a ProjectTypes table
 */
func GetProjectTypesByTypeId(pId int64) []*DOMAIN.ProjectTypes {
	// Slice to keep all ProjectTypes
	var ProjectTypes []*DOMAIN.ProjectTypes
	// Add all ProjectTypes in ProjectTypes variable
	err := getProjectTypesCollection().Find(db.Cond{"type_id": pId}).All(&ProjectTypes)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return ProjectTypes
}

/**
*	Name : GetProjectTypesByProjectIdAndTypeId
*	Params: pProjectId, pTypeId
*	Return: *DOMAIN.ProjectTypes
*	Description: Get a resourceSkill by SkillId in a ProjectTypes table
 */
func GetProjectTypesByProjectIdAndTypeId(pProjectId, pTypeId int) *DOMAIN.ProjectTypes {
	// keep  ProjectTypes
	var projectTypes *DOMAIN.ProjectTypes
	// Add all ProjectTypes in ProjectTypes variable
	res := getProjectTypesCollection().Find(db.Cond{"project_id": pProjectId}).And(db.Cond{"type_id": pTypeId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&projectTypes)
	if err != nil {
		log.Error(err)
	}
	return projectTypes
}

/**
*	Name : AddProjectTypes
*	Params: pProjectTypes
*	Return: int, error
*	Description: Add ProjectTypes in DB
 */
func AddTypeToProject(pProjectTypes *DOMAIN.ProjectTypes) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	res, err := session.InsertInto("ProjectTypes").Columns(
		"project_id",
		"type_id",
		"type_name").Values(
		pProjectTypes.ProjectId,
		pProjectTypes.TypeId,
		pProjectTypes.Name).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return insertId, nil
}

/**
*	Name : DeleteProjectTypes
*	Params: pProjectTypesId
*	Return: int, error
*	Description: Delete ProjectTypes in DB
 */
func DeleteProjectTypes(pProjectTypesId int64) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete ProjectTypes in DB
	q := session.DeleteFrom("ProjectTypes").Where("id", int(pProjectTypesId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return deleteCount, nil
}

/**
*	Name : DeleteProjectTypesByProjectIdAndTypeId
*	Params: pProjectId, pTypeId
*	Return: int, error
*	Description: Delete ProjectTypes in DB
 */
func DeleteProjectTypesByProjectIdAndTypeId(pProjectId, pTypeId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete ProjectTypes in DB
	q := session.DeleteFrom("ProjectTypes").Where("project_id", pProjectId).And("type_id", pTypeId)
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}
