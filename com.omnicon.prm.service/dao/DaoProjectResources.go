package dao

import (
	"bytes"
	"strconv"

	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getProjectResourcesCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getProjectResourcesCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("ProjectResources")
}

/**
*	Name : GetAllProjectResources
*	Return: []*DOMAIN.ProjectResources
*	Description: Get all projects and resources in a ProjectResources table
 */
func GetAllProjectResources() []*DOMAIN.ProjectResources {
	// Slice to keep all ProjectResources
	var projectResources []*DOMAIN.ProjectResources
	// Add all ProjectResources in projectResources variable
	err := getProjectResourcesCollection().Find().All(projectResources)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return projectResources
}

/**
*	Name : GetProjectResourcesById
*	Params: pId
*	Return: *DOMAIN.ProjectResources
*	Description: Get a projectResources by ID in a ProjectResources table
 */
func GetProjectResourcesById(pId int64) *DOMAIN.ProjectResources {
	// ProjectResources structure
	projectResources := DOMAIN.ProjectResources{}
	// Add in projectResources variable, the projectResources where ID is the same that the param
	res := getProjectResourcesCollection().Find(db.Cond{"id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&projectResources)
	if err != nil {
		log.Error(err)
	}
	return &projectResources
}

/**
*	Name : GetProjectResourcesByProjectId
*	Params: pId
*	Return: *DOMAIN.ProjectResources
*	Description: Get a projectResources by ProjectId in a ProjectResources table
 */
func GetProjectResourcesByProjectId(pId int64) []*DOMAIN.ProjectResources {
	// Slice to keep all ProjectResources
	var projectResources []*DOMAIN.ProjectResources
	// Add all ProjectResources in projectResources variable
	err := getProjectResourcesCollection().Find(db.Cond{"project_id": pId}).All(&projectResources)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return projectResources
}

/**
*	Name : GetProjectResourcesByResourceId
*	Params: pId
*	Return: *DOMAIN.ProjectResources
*	Description: Get a projectResources by ResourceId in a ProjectResources table
 */
func GetProjectResourcesByResourceId(pId int64) []*DOMAIN.ProjectResources {
	// Slice to keep all ProjectResources
	var projectResources []*DOMAIN.ProjectResources
	// Add all ProjectResources in projectResources variable
	err := getProjectResourcesCollection().Find(db.Cond{"resource_id": pId}).All(&projectResources)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return projectResources
}

/**
*	Name : GetProjectResourcesByProjectIdAndResourceId
*	Params: pId
*	Return: *DOMAIN.ProjectResources
*	Description: Get a projectResources by ProjectId and ResourceId in a ProjectResources table
 */
func GetProjectResourcesByProjectIdAndResourceId(pProjectId, pResourceId int64) *DOMAIN.ProjectResources {
	// ProjectResources structure
	projectResources := DOMAIN.ProjectResources{}
	// Add in projectResources variable, the projectResources where ID is the same that the param
	res := getProjectResourcesCollection().Find(db.Cond{"project_id": pProjectId}).And(db.Cond{"resource_id": pResourceId})
	// Close session when ends the method
	defer session.Close()
	count, err := res.Count()
	if count > 0 {
		err = res.One(&projectResources)
		if err != nil {
			log.Debug(err)
		}
		return &projectResources
	}

	return nil
}

/**
*	Name : AddProjectResources
*	Params: pProjectResources
*	Return: int, error
*	Description: Add ProjectResources in DB
 */
func AddProjectResources(pProjectResources *DOMAIN.ProjectResources) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	res, err := session.InsertInto("ProjectResources").Columns(
		"project_id",
		"resource_id",
		"resource_name",
		"start_date",
		"end_date",
		"lead").Values(
		pProjectResources.ProjectId,
		pProjectResources.ResourceId,
		pProjectResources.ResourceName,
		pProjectResources.StartDate,
		pProjectResources.EndDate,
		pProjectResources.Lead).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return insertId, nil
}

/**
*	Name : UpdateProjectResources
*	Params: pProjectResources
*	Return: int, error
*	Description: Update ProjectResources in DB
 */
func UpdateProjectResources(pProjectResources *DOMAIN.ProjectResources) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update ProjectResources in DB
	q := session.Update("ProjectResources").Set("project_id = ?, resource_id = ?, start_date = ?, end_date = ?, lead = ?", pProjectResources.ProjectId, pProjectResources.ResourceId, pProjectResources.StartDate, pProjectResources.EndDate, pProjectResources.Lead).Where("id = ?", int(pProjectResources.ID))
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
*	Name : DeleteProjectResources
*	Params: pProjectResourcesId
*	Return: int, error
*	Description: Delete ProjectResources in DB
 */
func DeleteProjectResources(pProjectResourcesId int64) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete ProjectResources in DB
	q := session.DeleteFrom("ProjectResources").Where("id", int(pProjectResourcesId))
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
*	Name : DeleteProjectResourcesByProjectIdAndResourceId
*	Params: pProjectId, pResourceId
*	Return: int, error
*	Description: Delete ProjectResources by ProjectId and ResourceId in DB
 */
func DeleteProjectResourcesByProjectIdAndResourceId(pProjectId, pResourceId int64) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete ProjectResources in DB
	q := session.DeleteFrom("ProjectResources").Where("project_id", int(pProjectId)).And("resource_id", int(pResourceId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return deleteCount, nil
}

func GetProjectsResourcesByFilters(pProjectResourceFilters *DOMAIN.ProjectResources, pStartDate, pEndDate *string, pLead *bool) ([]*DOMAIN.ProjectResources, string) {
	// Slice to keep all resources
	projectsResources := []*DOMAIN.ProjectResources{}
	result := getProjectResourcesCollection().Find()

	// Close session when ends the method
	defer session.Close()

	var filters bytes.Buffer
	if pProjectResourceFilters.ID != 0 {
		filters.WriteString("id = ")
		filters.WriteString(strconv.FormatInt(pProjectResourceFilters.ID, 10))
	}
	if pProjectResourceFilters.ProjectId != 0 {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("project_id = ")
		filters.WriteString(strconv.FormatInt(pProjectResourceFilters.ProjectId, 10))
	}
	if pProjectResourceFilters.ResourceId != 0 {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("resource_id = ")
		filters.WriteString(strconv.FormatInt(pProjectResourceFilters.ResourceId, 10))

	}
	if pProjectResourceFilters.ResourceName != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("resource_name = '")
		filters.WriteString(pProjectResourceFilters.ResourceName)
		filters.WriteString("'")

	}
	if pStartDate != nil {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("start_date >= '")
		filters.WriteString(*pStartDate)
		filters.WriteString("'")
	}
	if pEndDate != nil {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("end_date <= '")
		filters.WriteString(*pEndDate)
		filters.WriteString("'")
	}
	if pLead != nil {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("lead = '")
		filters.WriteString(strconv.FormatBool(*pLead))
		filters.WriteString("'")
	}
	err := result.Where(filters.String()).All(&projectsResources)

	if err != nil {
		log.Error(err)
	}

	return projectsResources, filters.String()
}
