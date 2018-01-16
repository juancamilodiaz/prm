package tool

import (
	"strconv"
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

func CreateProjectForecast(pRequest *DOMAIN.ProjectForecastRQ) *DOMAIN.CreateProjectForecastRS {

	timeResponse := time.Now()
	// Create response
	response := DOMAIN.CreateProjectForecastRS{}

	isValid, message := util.ValidateDates(&pRequest.StartDate, &pRequest.EndDate, true)
	if !isValid {
		response.Message = message
		response.ProjectForecast = nil
		response.Status = "Error"
		return &response
	}

	projectForecast := util.MappingCreateProjectForecast(pRequest)

	if projectForecast != nil {
		// Save in DB
		id, err := dao.AddProjectForecast(projectForecast)

		if err != nil {
			message := "ProjectForecast wasn't insert"
			log.Error(message)
			response.Message = message
			response.ProjectForecast = nil
			response.Status = "Error"
			return &response
		}
		if len(pRequest.AssignResources) > 0 {
			for typeId, mapProjectForecastAssigns := range pRequest.AssignResources {
				projectForecastAssigns := new(DOMAIN.ProjectForecastAssigns)
				typeRq := new(DOMAIN.TypeRQ)
				typeRq.ID, _ = strconv.Atoi(typeId)
				typeRS := GetTypeById(typeRq)
				if typeRS != nil && len(typeRS.Types) > 0 {
					if typeRS.Types[0].ApplyTo == "Resource" {
						projectForecastAssigns.TypeId = typeRS.Types[0].ID
						projectForecastAssigns.ProjectForecastId = id
						projectForecastAssigns.TypeName = typeRS.Types[0].Name
						projectForecastAssigns.ProjectForecastName = projectForecast.Name
						projectForecastAssigns.NumberResources = mapProjectForecastAssigns.NumberResources
						dao.AddProjectForecastAssigns(projectForecastAssigns)
					}
				}

			}
		}

		if len(pRequest.Types) > 0 {
			for _, typesRow := range pRequest.Types {

				projectForecastTypes := new(DOMAIN.ProjectForecastTypes)
				typeRq := new(DOMAIN.TypeRQ)
				typeRq.Name = typesRow
				typeRS := GetTypes(typeRq)
				if typeRS != nil && len(typeRS.Types) > 0 {
					projectForecastTypes.TypeId = typeRS.Types[0].ID
					projectForecastTypes.ProjectForecastId = id
					dao.AddProjectForecastType(projectForecastTypes)
				}
			}
		}

		// Get Project inserted
		projectForecast = dao.GetProjectForecastById(id)
		response.ProjectForecast = projectForecast
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)
		return &response
	}
	response.ProjectForecast = nil
	response.Status = "Error"

	message = "Error in creation of projectForecast"
	log.Error(message)
	response.Message = message

	response.Header = util.BuildHeaderResponse(timeResponse)
	return &response
}

func UpdateProjectForecast(pRequest *DOMAIN.ProjectForecastRQ) *DOMAIN.UpdateProjectForecastRS {
	timeResponse := time.Now()
	response := DOMAIN.UpdateProjectForecastRS{}

	isValid, message := util.ValidateDates(&pRequest.StartDate, &pRequest.EndDate, false)
	if !isValid {
		response.Message = message
		response.ProjectForecast = nil
		response.Status = "Error"
		return &response
	}

	oldProjectForecast := dao.GetProjectForecastById(pRequest.ID)
	if oldProjectForecast != nil {
		if pRequest.Name != "" {
			oldProjectForecast.Name = pRequest.Name
		}
		if pRequest.BusinessUnit != "" {
			oldProjectForecast.BusinessUnit = pRequest.BusinessUnit
		}
		if pRequest.Region != "" {
			oldProjectForecast.Region = pRequest.Region
		}
		if pRequest.Description != "" {
			oldProjectForecast.Description = pRequest.Description
		}
		if pRequest.StartDate != "" || pRequest.EndDate != "" {
			startDate := new(string)
			startDate = &pRequest.StartDate
			endDate := new(string)
			endDate = &pRequest.EndDate
			if startDate == nil || endDate == nil || *startDate == "" || *endDate == "" {
				log.Error("Dates undefined")
				return nil
			}
			startDateInt, endDateInt, err := util.ConvertirFechasPeticion(startDate, endDate)
			if err != nil {
				log.Error(err)
				return nil
			}
			if pRequest.StartDate != "" {
				oldProjectForecast.StartDate = time.Unix(startDateInt, 0)
			}
			if pRequest.StartDate != "" {
				oldProjectForecast.EndDate = time.Unix(endDateInt, 0)
			}
		}
		if pRequest.Hours != 0 {
			oldProjectForecast.Hours = pRequest.Hours
		}
		if pRequest.NumberSites != 0 {
			oldProjectForecast.NumberSites = pRequest.NumberSites
		}
		if pRequest.NumberProcessPerSite != 0 {
			oldProjectForecast.NumberProcessPerSite = pRequest.NumberProcessPerSite
		}
		if pRequest.NumberProcessTotal != 0 {
			oldProjectForecast.NumberProcessTotal = pRequest.NumberProcessTotal
		}
		if pRequest.EstimateCost != 0 {
			oldProjectForecast.EstimateCost = pRequest.EstimateCost
		}
		if pRequest.BillingDate != "" {
			billingDate := new(string)
			billingDate = &pRequest.BillingDate

			if billingDate == nil || *billingDate == "" {
				log.Error("Billing Date undefined")
				return nil
			}
			billingDateInt := util.GetDateInt64FromString(*billingDate)
			oldProjectForecast.BillingDate = time.Unix(billingDateInt, 0)
		}
		if pRequest.Status != "" {
			oldProjectForecast.Status = pRequest.Status
		}

		// Save in DB
		rowsUpdated, err := dao.UpdateProjectForecast(oldProjectForecast)
		if err != nil || rowsUpdated <= 0 {
			message := "ProjectForecast wasn't update"
			log.Error(message)
			response.Message = message
			response.ProjectForecast = nil
			response.Status = "Error"
			return &response
		}

		// Update project name in other tables
		projectsForecastAssigns := dao.GetProjectForecastAssignsByProjectId(pRequest.ID)
		for _, projectForecastAssign := range projectsForecastAssigns {
			for idStr, value := range pRequest.AssignResources {
				if idStr == strconv.Itoa(projectForecastAssign.TypeId) {
					projectForecastAssign.NumberResources = value.NumberResources
					dao.UpdateProjectForecastAssigns(projectForecastAssign)
				}
			}
		}

		// Get Prooject updated
		projectForecast := dao.GetProjectForecastById(pRequest.ID)
		response.ProjectForecast = projectForecast
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message = "Project forecast wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.ProjectForecast = nil
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func DeleteProjectForecast(pRequest *DOMAIN.ProjectForecastRQ) *DOMAIN.DeleteProjectForecastRS {
	timeResponse := time.Now()
	response := DOMAIN.DeleteProjectForecastRS{}
	projectForecastToDelete := dao.GetProjectForecastById(pRequest.ID)
	if projectForecastToDelete != nil {

		// Delete resources assignations for this project
		projectsForecastAssigns := dao.GetProjectForecastAssignsByProjectId(pRequest.ID)
		for _, projectForecastAssigns := range projectsForecastAssigns {
			_, err := dao.DeleteProjectForecastAssignsByProjectForecastIdAndTypeId(projectForecastAssigns.ProjectForecastId, projectForecastAssigns.TypeId)
			if err != nil {
				log.Error("Failed to delete project forecast assign")
			}
		}

		projectsForecastTypes := dao.GetProjectForecastTypesByProjectId(pRequest.ID)
		for _, projectForecastTypes := range projectsForecastTypes {
			_, err := dao.DeleteProjectForecastTypesByProjectIdAndTypeId(projectForecastTypes.ProjectForecastId, projectForecastTypes.TypeId)
			if err != nil {
				log.Error("Failed to delete project forecast types")
			}
		}

		// Delete in DB
		rowsDeleted, err := dao.DeleteProjectForecast(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "ProjectForecast wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.ID = projectForecastToDelete.ID
		response.Name = projectForecastToDelete.Name
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "ProjectForecast wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func SetProjectForecastAssigns(pRequest *DOMAIN.ProjectForecastAssignsRQ) *DOMAIN.SetProjectForecastAssignsRS {
	timeResponse := time.Now()
	response := DOMAIN.SetProjectForecastAssignsRS{}

	if pRequest.NumberResources <= 0 {
		response.Message = "Assigned resources must be greater than zero."
		response.ProjectForecastAssigns = nil
		response.Status = "Error"
		return &response
	}

	projectForecast := dao.GetProjectForecastById(pRequest.ProjectForecastId)
	if projectForecast != nil {
		// Get Type in DB
		typeDB := dao.GetTypesById(pRequest.TypeId)
		if typeDB != nil {
			projectForecastAssigns := DOMAIN.ProjectForecastAssigns{}
			projectForecastAssigns.ProjectForecastId = pRequest.ProjectForecastId
			projectForecastAssigns.ProjectForecastName = projectForecast.Name
			projectForecastAssigns.TypeId = typeDB.ID
			projectForecastAssigns.TypeName = typeDB.Name
			projectForecastAssigns.NumberResources = pRequest.NumberResources

			//find by type and projectForecast
			projectForecastAssignsExist := dao.GetProjectForecastAssignsById(pRequest.ID)
			if projectForecastAssignsExist != nil {

				if pRequest.NumberResources != 0 {
					projectForecastAssignsExist.NumberResources = pRequest.NumberResources
				}

				// Call update projectForecastassigns operation
				rowsUpdated, err := dao.UpdateProjectForecastAssigns(projectForecastAssignsExist)
				if err != nil || rowsUpdated <= 0 {
					message := "No Set Assign To Project"
					log.Error(message)
					response.Message = message
					response.ProjectForecastAssigns = nil
					response.Status = "Error"
					return &response
				}

				// Get ProjectResources inserted
				response := getInsertedProjectForecastAssigns(projectForecastAssignsExist.ID, timeResponse)
				if response != nil {
					return response
				}
			} else {

				id, err := dao.AddProjectForecastAssigns(&projectForecastAssigns)
				if err != nil {
					message := "No Set Assigns To Project"
					log.Error(message)
					response.Message = message
					response.ProjectForecastAssigns = nil
					response.Status = "Error"
					return &response
				}
				// Get ProjectResources inserted
				response := getInsertedProjectForecastAssigns(id, timeResponse)
				if response != nil {
					return response
				}
			}

		} else {
			message := "Type doesn't exist, plese create it"
			log.Error(message)
			response.Message = message
			response.Status = "Error"

			response.Header = util.BuildHeaderResponse(timeResponse)

			return &response
		}
	}
	message := "ProjectForecast doesn't exist, plese create it"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func getInsertedProjectForecastAssigns(pIdProjectForecastAssigns int, pTimeResponse time.Time) *DOMAIN.SetProjectForecastAssignsRS {
	response := DOMAIN.SetProjectForecastAssignsRS{}
	// Get ProjectForecastAssigns inserted
	projectForecastAssignsInserted := dao.GetProjectForecastAssignsById(pIdProjectForecastAssigns)
	if projectForecastAssignsInserted != nil {
		response.ProjectForecastAssigns = projectForecastAssignsInserted

		response.Header = util.BuildHeaderResponse(pTimeResponse)

		response.Status = "OK"

		return &response
	}
	return nil
}

func DeleteProjectForecastAssigns(pRequest *DOMAIN.DeleteProjectForecastAssignsRQ) *DOMAIN.DeleteProjectForecastAssignsRS {
	timeResponse := time.Now()
	response := DOMAIN.DeleteProjectForecastAssignsRS{}
	for index, id := range pRequest.IDs {
		projectForecastAssign := dao.GetProjectForecastAssignsById(id)
		if projectForecastAssign != nil {
			// Delete in DB
			rowsDeleted, err := dao.DeleteProjectForecastAssigns(projectForecastAssign.ID)
			if err != nil || rowsDeleted <= 0 {
				message := "ProjectForecastAssigns wasn't delete"
				log.Error(message)
				response.Message = message
				response.Status = "Error"
				return &response
			}

			response.IDs = append(response.IDs, projectForecastAssign.ID)
			if index == len(pRequest.IDs)-1 {
				response.Status = "OK"

				response.Header = util.BuildHeaderResponse(timeResponse)

				return &response
			}
		}
	}
	message := "Project Forecast Assigns wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func GetProjectsForecast(pRequest *DOMAIN.ProjectForecastRQ) *DOMAIN.GetProjectsForecastRS {
	timeResponse := time.Now()
	response := DOMAIN.GetProjectsForecastRS{}

	isValid, message := util.ValidateDates(&pRequest.StartDate, &pRequest.EndDate, false)
	if !isValid {
		response.Message = message
		response.Status = "Error"
		return &response
	}

	filters := util.MappingFiltersProjectForecast(pRequest)
	projectsForecast, filterString := dao.GetProjectsForecastByFilters(filters, pRequest.StartDate, pRequest.EndDate, pRequest.BillingDate)

	if len(projectsForecast) == 0 && filterString == "" {
		projectsForecast = dao.GetAllProjectsForecast()
	}
	if projectsForecast != nil && len(projectsForecast) > 0 {
		for _, project := range projectsForecast {
			totalEngineers := 0
			assignsProject := dao.GetProjectForecastAssignsByProjectId(project.ID)
			if len(assignsProject) > 0 {
				project.AssignResources = make(map[int]DOMAIN.ProjectForecastAssignResources)
			}
			for _, assignProject := range assignsProject {
				assign := DOMAIN.ProjectForecastAssignResources{}
				assign.Name = assignProject.TypeName
				assign.NumberResources = assignProject.NumberResources
				totalEngineers += assignProject.NumberResources
				project.AssignResources[assignProject.TypeId] = assign
			}
			project.TotalEngineers = totalEngineers
		}
		response.ProjectForecast = projectsForecast
		// Create response
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}
	message = "ProjectsForecast wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func GetProjectsForecastAssigns(pRequest *DOMAIN.ProjectForecastAssignsRQ) *DOMAIN.GetProjectForecastAssignsRS {
	timeResponse := time.Now()
	response := DOMAIN.GetProjectForecastAssignsRS{}

	filters := util.MappingSetProjectForecastAssigns(pRequest)
	projectsForecastAssigns, filterString := dao.GetProjectsForecastAssignsByFilters(filters)

	if len(projectsForecastAssigns) == 0 && filterString == "" {
		projectsForecastAssigns = dao.GetAllProjectForecastAssigns()
	}

	response.ProjectForecastAssigns = projectsForecastAssigns

	// Create response
	response.Status = "OK"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func getFilterProjectForecast(pStartDate, pEndDate string) []*DOMAIN.ProjectForecast {
	requestProjects := DOMAIN.ProjectForecastRQ{}
	requestProjects.StartDate = pStartDate
	requestProjects.EndDate = pEndDate

	//TODO filter in query enabled projects.
	responseProjectsForecast := GetProjectsForecast(&requestProjects)
	return responseProjectsForecast.ProjectForecast
}
