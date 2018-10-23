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
	if session != nil {
		// Return table resource in the session
		return session.Collection("ProjectResources")
	} else {
		return nil
	}
}

/**
*	Name : GetAllProjectResources
*	Return: []*DOMAIN.ProjectResources
*	Description: Get all projects and resources in a ProjectResources table
 */
func GetAllProjectResources() []*DOMAIN.ProjectResources {
	// Slice to keep all ProjectResources
	var projectResources []*DOMAIN.ProjectResources
	session := GetSession()
	if session != nil {
		// Add all ProjectResources in projectResources variable
		err := session.Select("p.id", "project_id", "resource_id", "project_name", "resource_name", "start_date", "end_date", "hours", "lead", "task", "assignated_by", "r.name", "r.last_name", "deliverable", "requirements", "priority", "additional_comments").From("ProjectResources AS p").Join("Resource AS r").On("p.assignated_by = r.id").All(&projectResources)
		//err := getProjectResourcesCollection().Find().All(&projectResources)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Error(err)
		}
	}
	return projectResources
}

/**
*	Name : GetProjectResourcesById
*	Params: pId
*	Return: *DOMAIN.ProjectResources
*	Description: Get a projectResources by ID in a ProjectResources table
 */
func GetProjectResourcesById(pId int) *DOMAIN.ProjectResources {
	// ProjectResources structure
	projectResources := DOMAIN.ProjectResources{}
	if getProjectResourcesCollection() != nil {
		// Add in projectResources variable, the projectResources where ID is the same that the param
		res := getProjectResourcesCollection().Find(db.Cond{"id": pId})
		// Close session when ends the method
		defer session.Close()
		err := res.One(&projectResources)
		if err != nil {
			log.Error(err)
		}
	}
	return &projectResources
}

/**
*	Name : GetProjectResourcesByProjectId
*	Params: pId
*	Return: *DOMAIN.ProjectResources
*	Description: Get a projectResources by ProjectId in a ProjectResources table
 */
func GetProjectResourcesByProjectId(pId int) []*DOMAIN.ProjectResources {
	// Slice to keep all ProjectResources
	var projectResources []*DOMAIN.ProjectResources

	if getProjectResourcesCollection() != nil {
		// Add all ProjectResources in projectResources variable
		err := getProjectResourcesCollection().Find(db.Cond{"project_id": pId}).All(&projectResources)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Debug(err)
		}
	}
	return projectResources
}

/**
*	Name : GetProjectResourcesByResourceId
*	Params: pId
*	Return: *DOMAIN.ProjectResources
*	Description: Get a projectResources by ResourceId in a ProjectResources table
 */
func GetProjectResourcesByResourceId(pId int) []*DOMAIN.ProjectResources {
	// Slice to keep all ProjectResources
	var projectResources []*DOMAIN.ProjectResources
	if getProjectResourcesCollection() != nil {
		// Add all ProjectResources in projectResources variable
		err := getProjectResourcesCollection().Find(db.Cond{"resource_id": pId}).All(&projectResources)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Debug(err)
		}
	}
	return projectResources
}

/**
*	Name : GetProjectResourcesByProjectIdAndResourceId
*	Params: pId
*	Return: *DOMAIN.ProjectResources
*	Description: Get a projectResources by ProjectId and ResourceId in a ProjectResources table
 */
// TODO this function return []*DOMAIN.ProjectResources refactor
/*func GetProjectResourcesByProjectIdAndResourceId(pProjectId, pResourceId int64) *DOMAIN.ProjectResources {
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
}*/

/**
*	Name : AddProjectResources
*	Params: pProjectResources
*	Return: int, error
*	Description: Add ProjectResources in DB
 */
func AddProjectResources(pProjectResources *DOMAIN.ProjectResources) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	if session != nil {
		defer session.Close()
		// Insert in DB
		res, err := session.InsertInto("ProjectResources").Columns(
			"project_id",
			"resource_id",
			"project_name",
			"resource_name",
			"start_date",
			"end_date",
			"lead",
			"hours").Values(
			pProjectResources.ProjectId,
			pProjectResources.ResourceId,
			pProjectResources.ProjectName,
			pProjectResources.ResourceName,
			pProjectResources.StartDate,
			pProjectResources.EndDate,
			pProjectResources.Lead,
			pProjectResources.Hours).Exec()
		if err != nil {
			log.Error(err)
			return 0, err
		}
		// Get rows inserted
		insertId, err := res.LastInsertId()
		return int(insertId), nil
	} else {
		return 0, nil
	}

}

/**
*	Name : UpdateProjectResources
*	Params: pProjectResources
*	Return: int, error
*	Description: Update ProjectResources in DB
 */
func UpdateProjectResources(pProjectResources *DOMAIN.ProjectResources) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Update ProjectResources in DB
		q := session.Update("ProjectResources").Set("project_id = ?, resource_id = ?, start_date = ?, end_date = ?, lead = ?, hours = ?, project_name = ?, resource_name = ?", pProjectResources.ProjectId, pProjectResources.ResourceId, pProjectResources.StartDate, pProjectResources.EndDate, pProjectResources.Lead, pProjectResources.Hours, pProjectResources.ProjectName, pProjectResources.ResourceName).Where("id = ?", int(pProjectResources.ID))
		res, err := q.Exec()
		if err != nil {
			log.Error(err)
			return 0, err
		}
		// Get rows updated
		updateCount, err := res.RowsAffected()
		return int(updateCount), nil
	} else {
		return 0, nil
	}
}

/**
*	Name : DeleteProjectResources
*	Params: pProjectResourcesId
*	Return: int, error
*	Description: Delete ProjectResources in DB
 */
func DeleteProjectResources(pProjectResourcesId int) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
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
		return int(deleteCount), nil
	} else {
		return 0, nil
	}
}

/**
*	Name : DeleteProjectResourcesByProjectIdAndResourceId
*	Params: pProjectId, pResourceId
*	Return: int, error
*	Description: Delete ProjectResources by ProjectId and ResourceId in DB
 */
func DeleteProjectResourcesByProjectIdAndResourceId(pProjectId int, pResourceId int) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Delete ProjectResources in DB
		q := session.DeleteFrom("ProjectResources").Where("project_id", pProjectId).And("resource_id", pResourceId)
		res, err := q.Exec()
		if err != nil {
			log.Error(err)
			return 0, err
		}
		// Get rows deleted
		deleteCount, err := res.RowsAffected()
		return int(deleteCount), nil
	} else {
		return 0, nil
	}
}

//GetProjectsResourcesByFilters gets prjects by filters at the struct
func GetProjectsResourcesByFilters(pProjectResourceFilters *DOMAIN.ProjectResources, pStartDate, pEndDate string, pLead *bool) ([]*DOMAIN.ProjectResources, string) {
	// Slice to keep all resources
	projectsResources := []*DOMAIN.ProjectResources{}
	var stringResponse string
	session := GetSession()
	if session != nil {
		//result := getProjectResourcesCollection().Find()
		result := session.Select("p.id", "project_id", "resource_id", "project_name", "resource_name", "start_date", "end_date", "hours", "lead", "task", "assignated_by", "r.name", "r.last_name", "deliverable", "requirements", "priority", "additional_comments").From("ProjectResources AS p").Join("Resource AS r").On("p.assignated_by = r.id")
		// Close session when ends the method
		//defer session.Close()

		var filters bytes.Buffer
		if pProjectResourceFilters.ID != 0 {
			filters.WriteString("id = ")
			filters.WriteString(strconv.Itoa(pProjectResourceFilters.ID))
		}
		if pProjectResourceFilters.ProjectId != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("project_id = ")
			filters.WriteString(strconv.Itoa(pProjectResourceFilters.ProjectId))
		}
		if pProjectResourceFilters.ResourceId != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("resource_id = ")
			filters.WriteString(strconv.Itoa(pProjectResourceFilters.ResourceId))

		}
		if pProjectResourceFilters.ProjectName != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("project_name = '")
			filters.WriteString(pProjectResourceFilters.ProjectName)
			filters.WriteString("'")

		}
		if pProjectResourceFilters.ResourceName != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("resource_name = '")
			filters.WriteString(pProjectResourceFilters.ResourceName)
			filters.WriteString("'")

		}
		if pStartDate != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("start_date >= '")
			filters.WriteString(pStartDate)
			filters.WriteString("'")
		}
		if pEndDate != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("end_date <= '")
			filters.WriteString(pEndDate)
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
		if pProjectResourceFilters.Hours != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("hours = ")
			filters.WriteString(strconv.FormatFloat(pProjectResourceFilters.Hours, 'f', -1, 64))
		}

		if pProjectResourceFilters.Task != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("task = '")
			filters.WriteString(pProjectResourceFilters.Task)
			filters.WriteString("'")
		}

		if pProjectResourceFilters.AssignatedBy != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("assignated_by = '")
			filters.WriteString(pProjectResourceFilters.AssignatedBy)
			filters.WriteString("'")
		}

		if pProjectResourceFilters.Deliverable != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("deliverable = '")
			filters.WriteString(pProjectResourceFilters.Deliverable)
			filters.WriteString("'")
		}

		if pProjectResourceFilters.Requirements != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("requirements = '")
			filters.WriteString(pProjectResourceFilters.Requirements)
			filters.WriteString("'")
		}

		if pProjectResourceFilters.Priority != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("priority = '")
			filters.WriteString(pProjectResourceFilters.Priority)
			filters.WriteString("'")
		}

		if pProjectResourceFilters.AdditionalComments != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("additional_comments = '")
			filters.WriteString(pProjectResourceFilters.AdditionalComments)
			filters.WriteString("'")
		}
		if filters.String() != "" {
			err := result.Where(filters.String()).All(&projectsResources)
			session.Close()
			if err != nil {
				log.Error(err)
			}
		}
		stringResponse = filters.String()
		//fmt.Println("query->", stringResponse, result.Where(filters.String()).String())
	}
	return projectsResources, stringResponse
}
