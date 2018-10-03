package dao

import (
	"bytes"
	"strconv"

	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getProjectForecastAssignsCollection
*	Return: db.Collection
*	Description: Get table ProjectForecastAssigns in a session
 */
func getProjectForecastAssignsCollection() db.Collection {
	// Get a session
	session = GetSession()
	if session != nil {
		// Return table resource in the session
		return session.Collection("ProjectForecastAssigns")
	} else {
		return nil
	}
}

/**
*	Name : GetAllProjectForecastAssigns
*	Return: []*DOMAIN.ProjectForecastAssigns
*	Description: Get all projects and resources in a ProjectForecastAssigns table
 */
func GetAllProjectForecastAssigns() []*DOMAIN.ProjectForecastAssigns {
	// Slice to keep all ProjectForecastAssigns
	var projectForecastAssigns []*DOMAIN.ProjectForecastAssigns

	if getProjectForecastAssignsCollection() != nil {
		// Add all ProjectForecastAssigns in projectForecastAssigns variable
		err := getProjectForecastAssignsCollection().Find().All(&projectForecastAssigns)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Error(err)
		}
	}
	return projectForecastAssigns
}

/**
*	Name : GetProjectForecastAssignsById
*	Params: pId
*	Return: *DOMAIN.ProjectForecastAssigns
*	Description: Get a projectForecastAssigns by ID in a ProjectForecastAssigns table
 */
func GetProjectForecastAssignsById(pId int) *DOMAIN.ProjectForecastAssigns {
	// ProjectForecastAssigns structure
	projectForecastAssigns := DOMAIN.ProjectForecastAssigns{}

	if getProjectForecastAssignsCollection() != nil {
		// Add in projectForecastAssigns variable, the projectForecastAssigns where ID is the same that the param
		res := getProjectForecastAssignsCollection().Find(db.Cond{"id": pId})
		// Close session when ends the method
		defer session.Close()
		err := res.One(&projectForecastAssigns)
		if err != nil {
			log.Error(err)
		}
	}
	return &projectForecastAssigns
}

/**
*	Name : GetProjectForecastAssignsByProjectId
*	Params: pId
*	Return: *DOMAIN.ProjectForecastAssigns
*	Description: Get a projectForecastAssigns by ProjectId in a ProjectForecastAssigns table
 */
func GetProjectForecastAssignsByProjectId(pId int) []*DOMAIN.ProjectForecastAssigns {
	// Slice to keep all ProjectForecastAssigns
	var projectForecastAssigns []*DOMAIN.ProjectForecastAssigns
	if getProjectForecastAssignsCollection() != nil {
		// Add all ProjectForecastAssigns in projectForecastAssigns variable
		err := getProjectForecastAssignsCollection().Find(db.Cond{"projectForecast_id": pId}).All(&projectForecastAssigns)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Debug(err)
		}
	}
	return projectForecastAssigns
}

/**
*	Name : GetProjectForecastAssignsByTypeId
*	Params: pId
*	Return: *DOMAIN.ProjectForecastAssigns
*	Description: Get a projectForecastAssigns by TypeId in a ProjectForecastAssigns table
 */
func GetProjectForecastAssignsByTypeId(pId int) []*DOMAIN.ProjectForecastAssigns {
	// Slice to keep all ProjectForecastAssigns
	var projectForecastAssigns []*DOMAIN.ProjectForecastAssigns
	if getProjectForecastAssignsCollection() != nil {
		// Add all ProjectForecastAssigns in projectForecastAssigns variable
		err := getProjectForecastAssignsCollection().Find(db.Cond{"type_id": pId}).All(&projectForecastAssigns)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Debug(err)
		}
	}
	return projectForecastAssigns
}

/**
*	Name : GetProjectForecastAssignsByProjectIdAndResourceId
*	Params: pId
*	Return: *DOMAIN.ProjectForecastAssigns
*	Description: Get a projectForecastAssigns by ProjectId and ResourceId in a ProjectForecastAssigns table
 */
// TODO this function return []*DOMAIN.ProjectForecastAssigns refactor
/*func GetProjectForecastAssignsByProjectIdAndResourceId(pProjectId, pResourceId int64) *DOMAIN.ProjectForecastAssigns {
	// ProjectForecastAssigns structure
	projectForecastAssigns := DOMAIN.ProjectForecastAssigns{}
	// Add in projectForecastAssigns variable, the projectForecastAssigns where ID is the same that the param
	res := getProjectForecastAssignsCollection().Find(db.Cond{"project_id": pProjectId}).And(db.Cond{"resource_id": pResourceId})
	// Close session when ends the method
	defer session.Close()
	count, err := res.Count()
	if count > 0 {
		err = res.One(&projectForecastAssigns)
		if err != nil {
			log.Debug(err)
		}
		return &projectForecastAssigns
	}

	return nil
}*/

/**
*	Name : AddProjectForecastAssigns
*	Params: pProjectForecastAssigns
*	Return: int, error
*	Description: Add ProjectForecastAssigns in DB
 */
func AddProjectForecastAssigns(pProjectForecastAssigns *DOMAIN.ProjectForecastAssigns) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Insert in DB
		res, err := session.InsertInto("ProjectForecastAssigns").Columns(
			"projectForecast_id",
			"projectForecast_name",
			"type_id",
			"type_name",
			"number_resources").Values(
			pProjectForecastAssigns.ProjectForecastId,
			pProjectForecastAssigns.ProjectForecastName,
			pProjectForecastAssigns.TypeId,
			pProjectForecastAssigns.TypeName,
			pProjectForecastAssigns.NumberResources).Exec()
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
*	Name : UpdateProjectForecastAssigns
*	Params: pProjectForecastAssigns
*	Return: int, error
*	Description: Update ProjectForecastAssigns in DB
 */
func UpdateProjectForecastAssigns(pProjectForecastAssigns *DOMAIN.ProjectForecastAssigns) (int, error) {
	// Get a session
	session = GetSession()

	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Update ProjectForecastAssigns in DB
		q := session.Update("ProjectForecastAssigns").Set("projectForecast_id = ?, projectForecast_name = ?, type_id = ?, type_name = ?, number_resources = ?", pProjectForecastAssigns.ProjectForecastId, pProjectForecastAssigns.ProjectForecastName, pProjectForecastAssigns.TypeId, pProjectForecastAssigns.TypeName, pProjectForecastAssigns.NumberResources).Where("id = ?", pProjectForecastAssigns.ID)
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
*	Name : DeleteProjectForecastAssigns
*	Params: pProjectForecastAssignsId
*	Return: int, error
*	Description: Delete ProjectForecastAssigns in DB
 */
func DeleteProjectForecastAssigns(pProjectForecastAssignsId int) (int, error) {
	// Get a session
	session = GetSession()

	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Delete ProjectForecastAssigns in DB
		q := session.DeleteFrom("ProjectForecastAssigns").Where("id", int(pProjectForecastAssignsId))
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
*	Name : DeleteProjectForecastAssignsByProjectForecastIdAndTypeId
*	Params: pProjectForecastId, pTypeId
*	Return: int, error
*	Description: Delete ProjectForecastAssigns by ProjectForecastId and TypeId in DB
 */
func DeleteProjectForecastAssignsByProjectForecastIdAndTypeId(pProjectForecastId int, pTypeId int) (int, error) {
	// Get a session
	session = GetSession()

	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Delete ProjectForecastAssigns in DB
		q := session.DeleteFrom("ProjectForecastAssigns").Where("projectForecast_id", pProjectForecastId).And("type_id", pTypeId)
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

func GetProjectsForecastAssignsByFilters(pProjectForecastAssignsFilters *DOMAIN.ProjectForecastAssigns) ([]*DOMAIN.ProjectForecastAssigns, string) {
	// Slice to keep all resources
	projectsForecastAssigns := []*DOMAIN.ProjectForecastAssigns{}
	var string_response string
	if getProjectForecastCollection() != nil {
		result := getProjectForecastAssignsCollection().Find()

		// Close session when ends the method
		defer session.Close()

		var filters bytes.Buffer
		if pProjectForecastAssignsFilters.ID != 0 {
			filters.WriteString("id = ")
			filters.WriteString(strconv.Itoa(pProjectForecastAssignsFilters.ID))
		}
		if pProjectForecastAssignsFilters.ProjectForecastId != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("projectForecast_id = ")
			filters.WriteString(strconv.Itoa(pProjectForecastAssignsFilters.ProjectForecastId))
		}
		if pProjectForecastAssignsFilters.TypeId != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("type_id = ")
			filters.WriteString(strconv.Itoa(pProjectForecastAssignsFilters.TypeId))

		}
		if pProjectForecastAssignsFilters.ProjectForecastName != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("projectForecast_name = '")
			filters.WriteString(pProjectForecastAssignsFilters.ProjectForecastName)
			filters.WriteString("'")

		}
		if pProjectForecastAssignsFilters.TypeName != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("type_name = '")
			filters.WriteString(pProjectForecastAssignsFilters.TypeName)
			filters.WriteString("'")

		}
		if pProjectForecastAssignsFilters.NumberResources != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("number_resources = ")
			filters.WriteString(strconv.Itoa(pProjectForecastAssignsFilters.NumberResources))
		}

		if filters.String() != "" {
			err := result.Where(filters.String()).All(&projectsForecastAssigns)

			if err != nil {
				log.Error(err)
			}
		}
		string_response = filters.String()
	}
	return projectsForecastAssigns, string_response
}
