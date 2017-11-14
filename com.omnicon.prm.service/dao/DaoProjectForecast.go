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
*	Name : getProjectForecastCollection
*	Return: db.Collection
*	Description: Get table ProjectForecast in a session
 */
func getProjectForecastCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table project forecast in the session
	return session.Collection("ProjectForecast")
}

/**
*	Name : GetAllProjects
*	Return: []*DOMAIN.ProjectForecast
*	Description: Get all projects forecast in a project forecast table
 */
func GetAllProjectsForecast() []*DOMAIN.ProjectForecast {
	// Slice to keep all projects forecast
	var projectsForecast []*DOMAIN.ProjectForecast
	// Add all projects forecast in projectsForecast variable
	err := getProjectForecastCollection().Find().All(&projectsForecast)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return projectsForecast
}

/**
*	Name : GetProjectForecastById
*	Params: pId
*	Return: *DOMAIN.ProjectForecast
*	Description: Get a projectForecast by ID in a projectForecast table
 */
func GetProjectForecastById(pId int) *DOMAIN.ProjectForecast {
	// Project structure
	projectForecast := DOMAIN.ProjectForecast{}
	// Add in projectForecast variable, the projectForecast where ID is the same that the param
	res := getProjectForecastCollection().Find(db.Cond{"id": pId})

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
*	Name : GetProjectsForecastByDateRange
*	Params: pStartDate, pEndDate
*	Return: []*DOMAIN.ProjectForecast
*	Description: Get a projectForecast in a date range in a projectForecast table
 */
func GetProjectsForecastByDateRange(pStartDate, pEndDate int64) []*DOMAIN.ProjectForecast {
	// Slice to keep all projectsForecast
	projectsForecast := []*DOMAIN.ProjectForecast{}
	startDate := time.Unix(pStartDate, 0).Format("20060102")
	endDate := time.Unix(pEndDate, 0).Format("20060102")
	// Filter projectsForecast by date range
	res := getProjectForecastCollection().Find().Where("start_date >= ?", startDate).And("end_date <= ?", endDate)
	// Close session when ends the method
	defer session.Close()
	// Add all projectsForecast in projectsForecast variable
	err := res.All(&projectsForecast)
	if err != nil {
		log.Error(err)
	}
	return projectsForecast
}

/**
*	Name : AddProjectForecast
*	Params: pProjectForecast
*	Return: int, error
*	Description: Add projectForecast in DB
 */
func AddProjectForecast(pProjectForecast *DOMAIN.ProjectForecast) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	res, err := session.InsertInto("ProjectForecast").Columns(
		"name",
		"business_unit",
		"region",
		"description",
		"start_date",
		"end_date",
		"hours",
		"number_sites",
		"number_process_per_site",
		"number_process_total",
		"estimate_cost",
		"billing_date",
		"status").Values(
		pProjectForecast.Name,
		pProjectForecast.BusinessUnit,
		pProjectForecast.Region,
		pProjectForecast.Description,
		pProjectForecast.StartDate,
		pProjectForecast.EndDate,
		pProjectForecast.Hours,
		pProjectForecast.NumberSites,
		pProjectForecast.NumberProcessPerSite,
		pProjectForecast.NumberProcessTotal,
		pProjectForecast.EstimateCost,
		pProjectForecast.BillingDate,
		pProjectForecast.Status).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()

	return int(insertId), nil
}

/**
*	Name : UpdateProjectForecast
*	Params: pProjectForecast
*	Return: int, error
*	Description: Update projectForecast in DB
 */
func UpdateProjectForecast(pProjectForecast *DOMAIN.ProjectForecast) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update project in DB
	q := session.Update("ProjectForecast").Set("name = ?, business_unit = ?, region = ?, description = ?, start_date = ?, end_date = ?, hours = ?, number_sites = ?, number_process_per_site = ?, number_process_total = ?, estimate_cost = ?, billing_date = ?, status = ?", pProjectForecast.Name, pProjectForecast.BusinessUnit, pProjectForecast.Region, pProjectForecast.Description, pProjectForecast.StartDate, pProjectForecast.EndDate, pProjectForecast.Hours, pProjectForecast.NumberSites, pProjectForecast.NumberProcessPerSite, pProjectForecast.NumberProcessTotal, pProjectForecast.EstimateCost, pProjectForecast.BillingDate, pProjectForecast.Status).Where("id = ?", int(pProjectForecast.ID))

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
*	Name : DeleteProjectForecast
*	Params: pProjectForecastId
*	Return: int, error
*	Description: Delete projectForecast in DB
 */
func DeleteProjectForecast(pProjectForecastId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete projectForecast in DB
	q := session.DeleteFrom("ProjectForecast").Where("id", pProjectForecastId)
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}

func GetProjectsForecastByFilters(pProjectForecastFilters *DOMAIN.ProjectForecast, pStartDate, pEndDate, pBillingDate string) ([]*DOMAIN.ProjectForecast, string) {
	// Slice to keep all projectsForecast
	projectsForecast := []*DOMAIN.ProjectForecast{}
	result := getProjectForecastCollection().Find()

	// Close session when ends the method
	defer session.Close()

	var filters bytes.Buffer
	if pProjectForecastFilters.ID != 0 {
		filters.WriteString("id = '")
		filters.WriteString(strconv.Itoa(pProjectForecastFilters.ID))
		filters.WriteString("'")
	}
	if pProjectForecastFilters.Name != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("name = '")
		filters.WriteString(pProjectForecastFilters.Name)
		filters.WriteString("'")
	}
	if pProjectForecastFilters.BusinessUnit != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("business_unit = '")
		filters.WriteString(pProjectForecastFilters.BusinessUnit)
		filters.WriteString("'")
	}
	if pProjectForecastFilters.Region != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("region = '")
		filters.WriteString(pProjectForecastFilters.Region)
		filters.WriteString("'")
	}
	if pProjectForecastFilters.Hours != 0 {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("hours = ")
		filters.WriteString(strconv.FormatFloat(pProjectForecastFilters.Hours, 'f', -1, 64))
	}
	if pProjectForecastFilters.NumberSites != 0 {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("number_sites = ")
		filters.WriteString(strconv.Itoa(pProjectForecastFilters.NumberSites))
	}
	if pProjectForecastFilters.NumberProcessPerSite != 0 {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("number_process_per_site = ")
		filters.WriteString(strconv.Itoa(pProjectForecastFilters.NumberProcessPerSite))
	}
	if pProjectForecastFilters.NumberProcessTotal != 0 {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("number_process_total = ")
		filters.WriteString(strconv.Itoa(pProjectForecastFilters.NumberProcessTotal))
	}
	if pProjectForecastFilters.EstimateCost != 0 {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("business_unit = ")
		filters.WriteString(strconv.FormatFloat(pProjectForecastFilters.EstimateCost, 'f', -1, 64))
	}
	if pProjectForecastFilters.Status != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("status = '")
		filters.WriteString(pProjectForecastFilters.Status)
		filters.WriteString("'")
	}
	/*
		if pProjectForecastFilters.ProjectType != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("type = '")
			filters.WriteString(pProjectForecastFilters.ProjectType)
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
	if pBillingDate != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("billing_date >= '")
		filters.WriteString(pBillingDate)
		filters.WriteString("'")
	}

	if filters.String() != "" {
		err := result.Where(filters.String()).All(&projectsForecast)

		if err != nil {
			log.Error(err)
		}
	}

	return projectsForecast, filters.String()
}
