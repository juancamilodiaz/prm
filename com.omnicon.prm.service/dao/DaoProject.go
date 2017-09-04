package dao

import (
	"bytes"
	"strconv"
	"time"

	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getProjectCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getProjectCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table project in the session
	return session.Collection("Project")
}

/**
*	Name : GetAllProjects
*	Return: []*DOMAIN.Project
*	Description: Get all projects in a project table
 */
func GetAllProjects() []*DOMAIN.Project {
	// Slice to keep all projects
	var projects []*DOMAIN.Project
	// Add all projects in projects variable
	err := getProjectCollection().Find().All(projects)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return projects
}

/**
*	Name : GetProjectById
*	Params: pId
*	Return: *DOMAIN.Project
*	Description: Get a project by ID in a project table
 */
func GetProjectById(pId int64) *DOMAIN.Project {
	// Project structure
	project := DOMAIN.Project{}
	// Add in project variable, the project where ID is the same that the param
	res := getProjectCollection().Find(db.Cond{"id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&project)
	if err != nil {
		log.Error(err)
	}
	return &project
}

/**
*	Name : GetProjectsByDateRange
*	Params: pStartDate, pEndDate
*	Return: []*DOMAIN.Project
*	Description: Get a project in a date range in a project table
 */
func GetProjectsByDateRange(pStartDate, pEndDate int64) []*DOMAIN.Project {
	// Slice to keep all projects
	projects := []*DOMAIN.Project{}
	startDate := time.Unix(pStartDate, 0).Format("YYYYMMdd")
	endDate := time.Unix(pEndDate, 0).Format("YYYYMMdd")
	// Filter projects by date range
	res := getProjectCollection().Find().Where("start_date >= ?", startDate).And("end_date <= ?", endDate)
	// Close session when ends the method
	defer session.Close()
	// Add all projects in projects variable
	err := res.All(&projects)
	if err != nil {
		log.Error(err)
	}
	return projects
}

/**
*	Name : AddProject
*	Params: pProject
*	Return: int, error
*	Description: Add project in DB
 */
func AddProject(pProject *DOMAIN.Project) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	res, err := session.InsertInto("Project").Columns(
		"name",
		"start_date",
		"end_date",
		"enabled").Values(
		pProject.Name,
		pProject.StartDate,
		pProject.EndDate,
		pProject.Enabled).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return insertId, nil
}

/**
*	Name : UpdateProject
*	Params: pProject
*	Return: int, error
*	Description: Update project in DB
 */
func UpdateProject(pProject *DOMAIN.Project) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update project in DB
	q := session.Update("Project").Set("name = ?, start_date = ?, end_date = ?, enabled = ?", pProject.Name, pProject.StartDate, pProject.EndDate, pProject.Enabled).Where("id = ?", int(pProject.ID))
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
*	Name : DeleteProject
*	Params: pProjectId
*	Return: int, error
*	Description: Delete project in DB
 */
func DeleteProject(pProjectId int64) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete project in DB
	q := session.DeleteFrom("Project").Where("id", int(pProjectId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return deleteCount, nil
}

func GetProjectsByFilters(pProjectFilters *DOMAIN.Project, pStartDate, pEndDate *string, pEnabled *bool) []*DOMAIN.Project {
	// Slice to keep all resources
	projects := []*DOMAIN.Project{}
	result := getProjectCollection().Find()
	var filters bytes.Buffer
	if pProjectFilters.Name != "" {
		filters.WriteString("name = '")
		filters.WriteString(pProjectFilters.Name)
		filters.WriteString("'")
	}
	if pStartDate != nil {
		filters.WriteString("start_date = '")
		filters.WriteString(*pStartDate)
		filters.WriteString("'")
	}
	if pEndDate != nil {
		filters.WriteString("end_date = '")
		filters.WriteString(*pEndDate)
		filters.WriteString("'")
	}
	if pEnabled != nil {
		filters.WriteString("enabled = '")
		filters.WriteString(strconv.FormatBool(*pEnabled))
		filters.WriteString("'")
	}
	err := result.Where(filters.String()).All(&projects)

	if err != nil {
		log.Error(err)
	}

	return projects
}
