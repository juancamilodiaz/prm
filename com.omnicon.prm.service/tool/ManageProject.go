package tool

import (
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
			projectResources.StartDate = time.Unix(startDateInt, 0)
			projectResources.EndDate = time.Unix(endDateInt, 0)
			projectResources.Lead = pRequest.Lead

			projectResourcesExist := dao.GetProjectResourcesByProjectIdAndResourceId(pRequest.ProjectId, pRequest.ResourceId)
			if projectResourcesExist != nil {
				if pRequest.ProjectId != 0 {
					projectResourcesExist.ProjectId = pRequest.ProjectId
				}
				if pRequest.ResourceId != 0 {
					projectResourcesExist.ResourceId = pRequest.ResourceId
				}
				if pRequest.StartDate != "" {
					projectResourcesExist.StartDate = time.Unix(startDateInt, 0)
				}
				if pRequest.EndDate != "" {
					projectResourcesExist.EndDate = time.Unix(endDateInt, 0)
				}
				projectResourcesExist.Lead = pRequest.Lead
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
				projectResourceUpdated := dao.GetProjectResourcesById(projectResourcesExist.ID)
				if projectResourceUpdated != nil {
					// Get all resources to this project
					resourcesOfProject := dao.GetProjectResourcesByProjectId(pRequest.ProjectId)
					// Mapping resources in the project of the response
					lead := util.MappingResourcesInAProject(project, resourcesOfProject)
					project.Lead = lead
					response.Project = project

					header := new(DOMAIN.SetResourceToProjectRS_Header)
					header.RequestDate = time.Now().String()
					responseTime := time.Now().Sub(timeResponse)
					header.ResponseTime = responseTime.String()
					response.Header = header

					response.Status = "OK"

					return &response
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
				projectResourceInserted := dao.GetProjectResourcesById(id)
				if projectResourceInserted != nil {
					// Get all resources to this project
					resourcesOfProject := dao.GetProjectResourcesByProjectId(pRequest.ProjectId)
					// Mapping resources in the project of the response
					lead := util.MappingResourcesInAProject(project, resourcesOfProject)
					project.Lead = lead
					response.Project = project

					header := new(DOMAIN.SetResourceToProjectRS_Header)
					header.RequestDate = time.Now().String()
					responseTime := time.Now().Sub(timeResponse)
					header.ResponseTime = responseTime.String()
					response.Header = header

					response.Status = "OK"

					return &response
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
	response.Projects = responseProjects.Projects

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
