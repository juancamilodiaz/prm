package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getProjectForecastCollection
*	Return: db.Collection
*	Description: Get table ProjectForecastTypes in a session
 */
func getProjectForecastTypesCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table project forecast in the session
	return session.Collection("ProjectForecastTypes")
}

/**
*	Name : GetAllProjectsForecastTypes
*	Return: []*DOMAIN.ProjectForecastTypes
*	Description: Get all projects forecast types in a project forecast types table
 */
func GetAllProjectsForecastTypes() []*DOMAIN.ProjectForecastTypes {
	// Slice to keep all projects forecast types
	var projectsForecastTypes []*DOMAIN.ProjectForecastTypes
	// Add all projects forecast types in projectsForecastTypes variable
	err := getProjectForecastTypesCollection().Find().All(&projectsForecastTypes)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return projectsForecastTypes
}

/**
*	Name : GetProjectForecastTypesById
*	Params: pId
*	Return: *DOMAIN.ProjectForecastTypes
*	Description: Get a projectForecastTypes by ID in a projectForecast table
 */
func GetProjectForecastTypesById(pId int) *DOMAIN.ProjectForecast {
	// Project structure
	projectForecast := DOMAIN.ProjectForecast{}
	// Add in projectForecast variable, the projectForecast where ID is the same that the param
	res := getProjectForecastTypesCollection().Find(db.Cond{"id": pId})

	//project.ProjectType = GetTypesByProjectId(pId)

	// Close session when ends the method
	defer session.Close()
	err := res.One(&projectForecast)
	if err != nil {
		log.Error(err)
		return nil
	}

	return &projectForecast
}

/**
*	Name : AddProjectForecastTypes
*	Params: pProjectForecastTypes
*	Return: int, error
*	Description: Add projectForecastTypes in DB
 */
func AddProjectForecastType(pProjectForecastTypes *DOMAIN.ProjectForecastTypes) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	res, err := session.InsertInto("ProjectForecastTypes").Columns(
		"projectForecast_id",
		"type_id").Values(
		pProjectForecastTypes.ProjectForecastId,
		pProjectForecastTypes.TypeId).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()

	return int(insertId), nil
}

/**
*	Name : UpdateProjectForecastTypes
*	Params: pProjectForecastTypes
*	Return: int, error
*	Description: Update projectForecastTypes in DB
 */
func UpdateProjectForecastTypes(pProjectForecastTypes *DOMAIN.ProjectForecastTypes) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update project in DB
	q := session.Update("ProjectForecastTypes").Set("projectForecast_id = ?, type_id = ?", pProjectForecastTypes.ProjectForecastId, pProjectForecastTypes.TypeId).Where("id = ?", int(pProjectForecastTypes.ID))

	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows updated
	updateCount, err := res.RowsAffected()
	return int(updateCount), nil
}

/**
*	Name : DeleteProjectForecastTypes
*	Params: pProjectForecastTypesId
*	Return: int, error
*	Description: Delete projectForecastTypes in DB
 */
func DeleteProjectForecastTypes(pProjectForecastTypesId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete projectForecastTypes in DB
	q := session.DeleteFrom("ProjectForecastTypes").Where("id", pProjectForecastTypesId)
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
*	Name : GetProjectForecastTypesByProjectForecastId
*	Params: pId
*	Return: *DOMAIN.ProjectForecastTypes
*	Description: Get a projectForecastType by ProjectForecastId in a ProjectForecastTypes table
 */
func GetProjectForecastTypesByProjectId(pProjectForecastId int) []*DOMAIN.ProjectForecastTypes {
	// Slice to keep all ProjectForecastTypes
	var projectForecastTypes []*DOMAIN.ProjectForecastTypes
	// Add all ProjectForecastTypes in ProjectForecastTypes variable
	err := getProjectForecastTypesCollection().Find(db.Cond{"projectForecast_id": pProjectForecastId}).All(&projectForecastTypes)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return projectForecastTypes
}

/**
*	Name : GetProjectForecastTypesByTypeId
*	Params: pId
*	Return: *DOMAIN.ProjectForecastTypes
*	Description: Get a projectForecastTypes by TypeId in a ProjectForecastTypes table
 */
func GetProjectForecastTypesByTypeId(pId int) []*DOMAIN.ProjectForecastTypes {
	// Slice to keep all ProjectForecastTypes
	var ProjectForecastTypes []*DOMAIN.ProjectForecastTypes
	// Add all ProjectForecastTypes in ProjectForecastTypes variable
	err := getProjectForecastTypesCollection().Find(db.Cond{"type_id": pId}).All(&ProjectForecastTypes)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return ProjectForecastTypes
}

/**
*	Name : GetProjectForecastTypesByProjectForecastIdAndTypeId
*	Params: pProjectForecastId, pTypeId
*	Return: *DOMAIN.ProjectForecastTypes
*	Description: Get a projectForecastTypes by TypeId and ProjectForecastId in a ProjectForecastTypes table
 */
func GetProjectForecastTypesByProjectForecastIdAndTypeId(pProjectForecastId, pTypeId int) *DOMAIN.ProjectForecastTypes {
	// keep  ProjectForecastTypes
	var projectForecastTypes *DOMAIN.ProjectForecastTypes
	// Add all ProjectForecastTypes in ProjectForecastTypes variable
	res := getProjectForecastTypesCollection().Find(db.Cond{"projectForecast_id": pProjectForecastId}).And(db.Cond{"type_id": pTypeId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&projectForecastTypes)
	if err != nil {
		log.Error(err)
	}
	return projectForecastTypes
}

/**
*	Name : DeleteProjectForecastTypesByProjectForecastIdAndTypeId
*	Params: pProjectForecastId, pTypeId
*	Return: int, error
*	Description: Delete ProjectForecastTypes in DB
 */
func DeleteProjectForecastTypesByProjectIdAndTypeId(pProjectForecastId, pTypeId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete ProjectForecastTypes in DB
	q := session.DeleteFrom("ProjectForecastTypes").Where("projectForecast_id", pProjectForecastId).And("type_id", pTypeId)
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}
