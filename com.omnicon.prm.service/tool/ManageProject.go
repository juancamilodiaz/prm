package tool

import (
	"strconv"
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

func CreateProject(pRequest *DOMAIN.CreateProjectRQ) *DOMAIN.CreateProjectRS {

	timeResponse := time.Now()
	// Create response
	response := DOMAIN.CreateProjectRS{}

	isValid, message := util.ValidateDates(&pRequest.StartDate, &pRequest.EndDate, true)
	if !isValid {
		response.Message = message
		response.Project = nil
		response.Status = "Error"
		return &response
	}

	project := util.MappingCreateProject(pRequest)

	if project != nil {
		// Save in DB
		id, err := dao.AddProject(project)

		if err != nil {
			message := "Project wasn't insert"
			log.Error(message)
			response.Message = message
			response.Project = nil
			response.Status = "Error"
			return &response
		}
		// Get Project inserted
		project = dao.GetProjectById(id)
		response.Project = project
		response.Status = "OK"

		header := new(DOMAIN.CreateProjectRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header
		return &response
	}
	response.Project = nil
	response.Status = "Error"

	message = "Error in creation of project"
	log.Error(message)
	response.Message = message

	header := new(DOMAIN.CreateProjectRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header
	return &response
}

func UpdateProject(pRequest *DOMAIN.UpdateProjectRQ) *DOMAIN.UpdateProjectRS {
	timeResponse := time.Now()
	response := DOMAIN.UpdateProjectRS{}

	isValid, message := util.ValidateDates(&pRequest.StartDate, &pRequest.EndDate, false)
	if !isValid {
		response.Message = message
		response.Project = nil
		response.Status = "Error"
		return &response
	}

	oldProject := dao.GetProjectById(pRequest.ID)
	if oldProject != nil {
		if pRequest.Name != "" {
			oldProject.Name = pRequest.Name
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
				oldProject.StartDate = time.Unix(startDateInt, 0)
			}
			if pRequest.StartDate != "" {
				oldProject.EndDate = time.Unix(endDateInt, 0)
			}

			// Validation for updating dates, these should not be outside the resource assignment range.
			resourcesProject := dao.GetProjectResourcesByProjectId(pRequest.ID)
			for _, resource := range resourcesProject {
				if resource.StartDate.Unix() < oldProject.StartDate.Unix() || resource.EndDate.Unix() > oldProject.EndDate.Unix() {
					message := "Can not update the project, there are resources allocated outside the new dates. (" + resource.StartDate.Format("2006-01-02") + " to " + resource.EndDate.Format("2006-01-02") + ")"
					log.Error(message)
					response.Message = message
					response.Project = nil
					response.Status = "Error"
					return &response
				}
			}
		}
		oldProject.Enabled = pRequest.Enabled
		// Save in DB
		rowsUpdated, err := dao.UpdateProject(oldProject)
		if err != nil || rowsUpdated <= 0 {
			message := "Project wasn't update"
			log.Error(message)
			response.Message = message
			response.Project = nil
			response.Status = "Error"
			return &response
		}
		// Get Prooject updated
		project := dao.GetProjectById(pRequest.ID)
		response.Project = project
		response.Status = "OK"

		header := new(DOMAIN.UpdateProjectRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}

	message = "Resource wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Project = nil
	response.Status = "Error"

	header := new(DOMAIN.UpdateProjectRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func DeleteProject(pRequest *DOMAIN.DeleteProjectRQ) *DOMAIN.DeleteProjectRS {
	timeResponse := time.Now()
	response := DOMAIN.DeleteProjectRS{}
	projectToDelete := dao.GetProjectById(pRequest.ID)
	if projectToDelete != nil {

		// Delete resources assignations for this project
		resourcesProject := dao.GetProjectResourcesByProjectId(pRequest.ID)
		for _, resource := range resourcesProject {
			_, err := dao.DeleteProjectResourcesByProjectIdAndResourceId(resource.ProjectId, resource.ResourceId)
			if err != nil {
				log.Error("Failed to delete project resource")
			}
		}

		// Delete in DB
		rowsDeleted, err := dao.DeleteProject(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "Project wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.ID = projectToDelete.ID
		response.Name = projectToDelete.Name
		response.Status = "OK"

		header := new(DOMAIN.DeleteProjectRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}

	message := "Project wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	header := new(DOMAIN.DeleteProjectRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func SetResourceToProject(pRequest *DOMAIN.SetResourceToProjectRQ) *DOMAIN.SetResourceToProjectRS {
	timeResponse := time.Now()
	response := DOMAIN.SetResourceToProjectRS{}

	isValid, message := util.ValidateDates(&pRequest.StartDate, &pRequest.EndDate, false)
	if !isValid {
		response.Message = message
		response.Project = nil
		response.Status = "Error"
		return &response
	}

	project := dao.GetProjectById(pRequest.ProjectId)
	if project != nil {
		// Get Resource in DB
		resource := dao.GetResourceById(pRequest.ResourceId)
		if resource != nil {
			projectResources := DOMAIN.ProjectResources{}
			projectResources.ResourceId = pRequest.ResourceId
			projectResources.ProjectName = project.Name
			projectResources.ResourceName = resource.Name + " " + resource.LastName
			projectResources.ProjectId = pRequest.ProjectId
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

			// validate dates assignation resource
			if project.StartDate.Unix() > startDateInt || project.EndDate.Unix() < endDateInt {
				response.Message = "The resource is being allocated outside the project dates. " + project.StartDate.Format("2006-01-02") + " to " + project.EndDate.Format("2006-01-02")
				response.Project = nil
				response.Status = "Error"
				return &response
			}

			// Validate hours available per day
			assignations := dao.GetProjectResourcesByResourceId(pRequest.ResourceId)
			for _, assignation := range assignations {
				if assignation.StartDate.Unix() <= endDateInt && assignation.EndDate.Unix() >= startDateInt {

					var days float64
					for day := assignation.StartDate; day.Unix() <= assignation.EndDate.Unix(); day = day.AddDate(0, 0, 1) {
						if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
							days++
						}
					}
					var hoursByDay float64
					if days != 0 {
						hoursByDay = assignation.Hours / days
					}

					var daysNew float64
					for day := time.Unix(startDateInt, 0); day.Unix() <= time.Unix(endDateInt, 0).Unix(); day = day.AddDate(0, 0, 1) {
						if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
							daysNew++
						}
					}
					var hoursByDayNew float64
					if daysNew != 0 {
						hoursByDayNew = pRequest.Hours / daysNew
					}

					totalHoursDay := hoursByDay + hoursByDayNew

					// If the hours exceed the allowed hours per day
					if hoursByDay == 8 || totalHoursDay > 8 {
						response.Message = util.Concatenate("The allocation of hours exceeds the limit of 8 hours per day. (", strconv.FormatFloat(totalHoursDay, 'f', -1, 64), "Hrs ", assignation.StartDate.Format("2006-01-02"), " to ", assignation.EndDate.Format("2006-01-02"), " in ", assignation.ProjectName, " project)")
						response.Project = nil
						response.Status = "Error"
						return &response
					}
				}
			}

			projectResources.StartDate = time.Unix(startDateInt, 0)
			projectResources.EndDate = time.Unix(endDateInt, 0)
			projectResources.Lead = pRequest.Lead
			projectResources.Hours = pRequest.Hours

			//find by resource and project
			projectResourcesExist := dao.GetProjectResourcesByProjectIdAndResourceId(pRequest.ProjectId, pRequest.ResourceId)
			if !pRequest.IsToCreate && projectResourcesExist != nil {

				if pRequest.StartDate != "" {
					projectResourcesExist.StartDate = time.Unix(startDateInt, 0)
				}
				if pRequest.EndDate != "" {
					projectResourcesExist.EndDate = time.Unix(endDateInt, 0)
				}
				projectResourcesExist.Lead = pRequest.Lead
				if pRequest.Hours != 0 {
					projectResourcesExist.Hours = pRequest.Hours
				}
				// Call update projectResources operation
				rowsUpdated, err := dao.UpdateProjectResources(projectResourcesExist)
				if err != nil || rowsUpdated <= 0 {
					message := "No Set Resource To Project"
					log.Error(message)
					response.Message = message
					response.Project = nil
					response.Status = "Error"
					return &response
				}

				// Get ProjectResources inserted
				response := getInsertedResource(projectResourcesExist.ID, project, timeResponse)
				if response != nil {
					return response
				}
			} else {
				id, err := dao.AddProjectResources(&projectResources)
				if err != nil {
					message := "No Set Resource To Project"
					log.Error(message)
					response.Message = message
					response.Project = nil
					response.Status = "Error"
					return &response
				}
				// Get ProjectResources inserted
				response := getInsertedResource(id, project, timeResponse)
				if response != nil {
					return response
				}
			}

		} else {
			message := "Resource doesn't exist, plese create it"
			log.Error(message)
			response.Message = message
			response.Status = "Error"

			header := new(DOMAIN.SetResourceToProjectRS_Header)
			header.RequestDate = time.Now().String()
			responseTime := time.Now().Sub(timeResponse)
			header.ResponseTime = responseTime.String()
			response.Header = header

			return &response
		}
	}
	message = "Project doesn't exist, plese create it"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	header := new(DOMAIN.SetResourceToProjectRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func getInsertedResource(pIdResProject int64, pProject *DOMAIN.Project, pTimeResponse time.Time) *DOMAIN.SetResourceToProjectRS {
	response := DOMAIN.SetResourceToProjectRS{}
	// Get ProjectResources inserted
	projectResourceInserted := dao.GetProjectResourcesById(pIdResProject)
	if projectResourceInserted != nil {
		// Get all resources to this project
		resourcesOfProject := dao.GetProjectResourcesByProjectId(pProject.ID)
		// Mapping resources in the project of the response
		lead := util.MappingResourcesInAProject(pProject, resourcesOfProject)
		pProject.Lead = lead
		response.Project = pProject

		header := new(DOMAIN.SetResourceToProjectRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(pTimeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		response.Status = "OK"

		return &response
	}
	return nil
}

func DeleteResourceToProject(pRequest *DOMAIN.DeleteResourceToProjectRQ) *DOMAIN.DeleteResourceToProjectRS {
	timeResponse := time.Now()
	response := DOMAIN.DeleteResourceToProjectRS{}
	projectResource := dao.GetProjectResourcesByProjectIdAndResourceId(pRequest.ProjectId, pRequest.ResourceId)
	if projectResource != nil {
		// Delete in DB
		rowsDeleted, err := dao.DeleteProjectResourcesByProjectIdAndResourceId(pRequest.ProjectId, pRequest.ResourceId)
		if err != nil || rowsDeleted <= 0 {
			message := "ProjectResource wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.ID = projectResource.ID
		project := dao.GetProjectById(projectResource.ProjectId)
		response.ProjectName = project.Name
		resource := dao.GetResourceById(projectResource.ResourceId)
		if resource == nil {
			message := "Resource is not in DB"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}
		response.ResourceName = resource.Name
		response.Status = "OK"

		header := new(DOMAIN.DeleteResourceToProjectRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}
	message := "ResourceSkill wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	header := new(DOMAIN.DeleteResourceToProjectRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func GetProjects(pRequest *DOMAIN.GetProjectsRQ) *DOMAIN.GetProjectsRS {
	timeResponse := time.Now()
	response := DOMAIN.GetProjectsRS{}

	isValid, message := util.ValidateDates(&pRequest.StartDate, &pRequest.EndDate, false)
	if !isValid {
		response.Message = message
		response.Status = "Error"
		return &response
	}

	filters := util.MappingFiltersProject(pRequest)
	projects, filterString := dao.GetProjectsByFilters(filters, pRequest.StartDate, pRequest.EndDate, pRequest.Enabled)

	if len(projects) == 0 && filterString == "" {
		projects = dao.GetAllProjects()
	}

	if projects != nil && len(projects) > 0 {
		/*
			for _, project := range projects {
				resourcesProject := dao.GetProjectResourcesByProjectId(project.ID)
				if len(resourcesProject) > 0 {
					project.ResourceAssign = make(map[int64]*DOMAIN.ResourceAssign)
				}
				for _, resourceProject := range resourcesProject {
					resource := dao.GetResourceById(resourceProject.ResourceId)
					if resource != nil {
						if resourceProject.Lead {
							project.Lead = resource.Name
						}

						resourceSkill := dao.GetResourceSkillsByResourceId(resource.ID)
						if len(resourceSkill) > 0 {
							util.MappingSkillsInAResource(resource, resourceSkill)
						}

						resourceAssign := new(DOMAIN.ResourceAssign)
						resourceAssign.Resource = resource
						resourceAssign.Lead = resourceProject.Lead
						resourceAssign.StartDate = resourceProject.StartDate
						resourceAssign.EndDate = resourceProject.EndDate
						project.ResourceAssign[resource.ID] = resourceAssign
					}
				}
			}
		*/
		response.Projects = projects
		// Create response
		response.Status = "OK"

		header := new(DOMAIN.GetProjectsRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}
	message = "Projects wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	header := new(DOMAIN.GetProjectsRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func GetResourcesToProjects(pRequest *DOMAIN.GetResourcesToProjectsRQ) *DOMAIN.GetResourcesToProjectsRS {
	timeResponse := time.Now()
	response := DOMAIN.GetResourcesToProjectsRS{}

	isValid, message := util.ValidateDates(&pRequest.StartDate, &pRequest.EndDate, false)
	if !isValid {
		response.Message = message
		response.Status = "Error"
		return &response
	}

	filters := util.MappingFiltersProjectResource(pRequest)
	projectsResources, filterString := dao.GetProjectsResourcesByFilters(filters, pRequest.StartDate, pRequest.EndDate, pRequest.Lead)

	if len(projectsResources) == 0 && filterString == "" {
		projectsResources = dao.GetAllProjectResources()
	}

	requestProjects := DOMAIN.GetProjectsRQ{}
	responseProjects := GetProjects(&requestProjects)
	for _, project := range responseProjects.Projects {
		// only return projects enabled
		if project.Enabled {
			response.Projects = append(response.Projects, project)
		}
	}

	requestResources := DOMAIN.GetResourcesRQ{}
	responseResources := GetResources(&requestResources)
	for _, resource := range responseResources.Resources {
		// only return resources enabled
		if resource.Enabled {
			response.Resources = append(response.Resources, resource)
		}
	}
	if projectsResources != nil && len(projectsResources) > 0 {

		response.ResourcesToProjects = projectsResources
		// Create response
		response.Status = "OK"

		header := new(DOMAIN.GetResourcesToProjectsRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}
	message = "Resources To Projects wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	header := new(DOMAIN.GetResourcesToProjectsRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}
