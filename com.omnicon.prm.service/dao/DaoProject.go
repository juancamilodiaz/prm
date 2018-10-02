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
	if session != nil {
		return session.Collection("Project")
	} else {
		return nil
	}

}

/**
*	Name : GetAllProjects
*	Return: []*DOMAIN.Project
*	Description: Get all projects in a project table
 */
func GetAllProjects() []*DOMAIN.Project {
	// Slice to keep all projects
	var projects []*DOMAIN.Project
	result_ini := getProjectCollection()

	if result_ini != nil {
		err := result_ini.Find().All(&projects)

		defer session.Close()
		if err != nil {
			log.Error(err)
		}
	}
	// Add all projects in projects variable
	// Close session when ends the method

	return projects
}

/**
*	Name : GetProjectById
*	Params: pId
*	Return: *DOMAIN.Project
*	Description: Get a project by ID in a project table
 */
func GetProjectById(pId int) *DOMAIN.Project {
	// Project structure
	project := DOMAIN.Project{}
	// Add in project variable, the project where ID is the same that the param
	res := getProjectCollection().Find(db.Cond{"id": pId})

	//project.ProjectType = GetTypesByProjectId(pId)

	// Close session when ends the method
	defer session.Close()
	err := res.One(&project)
	if err != nil {
		log.Error(err)
		return nil
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
	startDate := time.Unix(pStartDate, 0).Format("20060102")
	endDate := time.Unix(pEndDate, 0).Format("20060102")
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
*	Name : GetProjectsByLeaderID
*	Params: pLeaderID
*	Return: []*DOMAIN.Project
*	Description: Get a project by leader ID in a project table
 */
func GetProjectsByLeaderID(pLeaderID int) []*DOMAIN.Project {
	// Slice to keep all projects
	projects := []*DOMAIN.Project{}
	// Filter projects by leader id
	res := getProjectCollection().Find().Where("leader_id = ?", pLeaderID)
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
func AddProject(pProject *DOMAIN.Project) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	res, err := session.InsertInto("Project").Columns(
		"name",
		"start_date",
		"end_date",
		"enabled",
		"operation_center",
		"work_order",
		"leader_id",
		"cost").Values(
		pProject.Name,
		pProject.StartDate,
		pProject.EndDate,
		pProject.Enabled,
		pProject.OperationCenter,
		pProject.WorkOrder,
		pProject.LeaderID,
		pProject.Cost).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()

	return int(insertId), nil
}

/**
*	Name : UpdateProject
*	Params: pProject
*	Return: int, error
*	Description: Update project in DB
 */
func UpdateProject(pProject *DOMAIN.Project) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update project in DB
	q := session.Update("Project").Set("name = ?, start_date = ?, end_date = ?, enabled = ?, operation_center = ?, work_order = ?, leader_id = ?, cost = ?",
		pProject.Name, pProject.StartDate, pProject.EndDate, pProject.Enabled, pProject.OperationCenter, pProject.WorkOrder, pProject.LeaderID, pProject.Cost).Where("id = ?", int(pProject.ID))

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
*	Name : DeleteProject
*	Params: pProjectId
*	Return: int, error
*	Description: Delete project in DB
 */
func DeleteProject(pProjectId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete project in DB
	q := session.DeleteFrom("Project").Where("id", pProjectId)
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}

func GetProjectsByFilters(pProjectFilters *DOMAIN.Project, pStartDate, pEndDate string, pEnabled *bool) ([]*DOMAIN.Project, string) {
	// Slice to keep all projects
	projects := []*DOMAIN.Project{}
	var string_response string
	

	result_ini := getProjectCollection()

	if result_ini != nil {
		result := result_ini.Find()
		fmt.Println(result)

		defer session.Close()

		var filters bytes.Buffer
		if pProjectFilters.ID != 0 {
			filters.WriteString("id = '")
			filters.WriteString(strconv.Itoa(pProjectFilters.ID))
			filters.WriteString("'")
		}

		if pProjectFilters.Name != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("name = '")
			filters.WriteString(pProjectFilters.Name)
			filters.WriteString("'")
		}
		/*
			if pProjectFilters.ProjectType != "" {
				if filters.String() != "" {
					filters.WriteString(" and ")
				}
				filters.WriteString("type = '")
				filters.WriteString(pProjectFilters.ProjectType)
				filters.WriteString("'")
			}
		*/
		if pStartDate != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("end_date >= '")
			filters.WriteString(pStartDate)
			filters.WriteString("'")
		}
		if pEndDate != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("start_date <= '")
			filters.WriteString(pEndDate)
			filters.WriteString("'")
		}
		if pEnabled != nil {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("enabled = '")
			filters.WriteString(strconv.FormatBool(*pEnabled))
			filters.WriteString("'")
		}
		if pProjectFilters.OperationCenter != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("operation_center = '")
			filters.WriteString(pProjectFilters.OperationCenter)
			filters.WriteString("'")
		}
		if pProjectFilters.WorkOrder != 0 {
			filters.WriteString("work_order = '")
			filters.WriteString(strconv.Itoa(pProjectFilters.WorkOrder))
			filters.WriteString("'")
		}

		if filters.String() != "" {
			err := result.Where(filters.String()).All(&projects)

			if err != nil {
				log.Error(err)
			}
		}

		string_response = filters.String()

	}
	
	return projects, string_response
}
