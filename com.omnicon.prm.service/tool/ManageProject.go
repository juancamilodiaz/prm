package tool

import (
	"database/sql"
	"strconv"
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

var HoursOfWork, EpsilonValue float64

func init() {
	if dao.GetSession() != nil {
		UpdateSettingsVariables()
	}

}

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

	// Set leader id (resource id)
	resource := dao.GetResourceById(pRequest.LeaderID)
	if resource != nil {
		leaderID := resource.ID
		project.LeaderID = &leaderID
	}

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

		if len(pRequest.ProjectType) > 0 {
			for _, typesRow := range pRequest.ProjectType {
				projectTypes := new(DOMAIN.ProjectTypes)

				val, _ := strconv.Atoi(typesRow)
				typeRq := new(DOMAIN.TypeRQ)
				typeRq.ID = val
				typeRS := GetTypeById(typeRq)
				if typeRS != nil && len(typeRS.Types) > 0 {
					projectTypes.TypeId = val
					projectTypes.ProjectId = id
					projectTypes.Name = typeRS.Types[0].Name
					dao.AddTypeToProject(projectTypes)
				}

			}
		}

		// Get Project inserted
		project = dao.GetProjectById(id)
		response.Project = project
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)
		return &response
	}
	response.Project = nil
	response.Status = "Error"

	message = "Error in creation of project"
	log.Error(message)
	response.Message = message

	response.Header = util.BuildHeaderResponse(timeResponse)
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
		if pRequest.OperationCenter != "" {
			oldProject.OperationCenter = pRequest.OperationCenter
		}
		if pRequest.WorkOrder != 0 {
			oldProject.WorkOrder = pRequest.WorkOrder
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
			//if pRequest.ProjectType != nil && len(pRequest.ProjectType) > 0 {
			/*for _, typesRow := range pRequest.ProjectType {
				projectTypes := new(DOMAIN.Type)

				val, _ := strconv.Atoi(typesRow)
				projectTypes.TypeId = val
				projectTypes.ProjectId = pRequest.ID
				oldProject.ProjectType = append(oldProject.ProjectType, projectTypes)
			}*/
			//TODO update projectType

			//}

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

		resourceID := 0
		if pRequest.LeaderID != 0 {
			resource := dao.GetResourceById(pRequest.LeaderID)
			if resource != nil {
				resourceID = resource.ID
			}
		}
		if resourceID != 0 {
			oldProject.LeaderID = &resourceID
		} else {
			oldProject.LeaderID = nil
		}

		if pRequest.Cost > 0 {
			cost := pRequest.Cost
			oldProject.Cost = &cost
		} else {
			if pRequest.Cost == 0 {
				oldProject.Cost = nil
			}
		}

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

		// Update project name in other tables
		projectsResources := dao.GetProjectResourcesByProjectId(pRequest.ID)
		for _, projectResource := range projectsResources {
			projectResource.ProjectName = oldProject.Name
			dao.UpdateProjectResources(projectResource)
		}

		// Get Prooject updated
		project := dao.GetProjectById(pRequest.ID)
		response.Project = project
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message = "Resource wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Project = nil
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

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

		// Delete types assignations for this project
		typesProject := dao.GetProjectTypesByProjectId(pRequest.ID)
		for _, typeP := range typesProject {
			_, err := dao.DeleteProjectTypesByProjectIdAndTypeId(int(typeP.ProjectId), typeP.TypeId)
			if err != nil {
				log.Error("Failed to delete project type")
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

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Project wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func SetResourceToProject(pRequest *DOMAIN.SetResourceToProjectRQ) *DOMAIN.SetResourceToProjectRS {
	timeResponse := time.Now()
	response := DOMAIN.SetResourceToProjectRS{}

	if pRequest.Hours <= 0 {
		response.Message = "Assigned hours must be greater than zero."
		response.Project = nil
		response.Status = "Error"
		return &response
	}

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

			// breakdown exist assignation map[day]hours
			breakdown := make(map[string]float64)

			for _, assignation := range assignations {
				// Except the actual assignation, apply in update.
				if assignation.ID != pRequest.ID {
					if assignation.StartDate.Unix() <= endDateInt && assignation.EndDate.Unix() >= startDateInt {

						totalHours := assignation.Hours

						for day := assignation.StartDate; day.Unix() <= assignation.EndDate.Unix(); day = day.AddDate(0, 0, 1) {
							if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
								if totalHours > 0 && totalHours <= HoursOfWork {
									breakdown[day.String()] += totalHours
									break
								} else {
									breakdown[day.String()] += HoursOfWork
									totalHours = totalHours - HoursOfWork
								}
							}
						}
					}
				}
			}
			log.Debug("breakdownSet", breakdown)

			// breakdown new assignation map[day]hours
			breakdownAssig := make(map[string]float64)
			totalHoursAssig := pRequest.Hours

			// if not are hours per day then get the total hours
			if !pRequest.IsHoursPerDay {
				pRequest.HoursPerDay = pRequest.Hours
			}

			for day := time.Unix(startDateInt, 0); day.Unix() <= time.Unix(endDateInt, 0).Unix(); day = day.AddDate(0, 0, 1) {
				if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
					if pRequest.HoursPerDay > 0 && pRequest.HoursPerDay <= HoursOfWork {
						breakdownAssig[day.String()] = pRequest.HoursPerDay
						totalHoursAssig = totalHoursAssig - pRequest.HoursPerDay
					} else if totalHoursAssig != 0 {
						hoursAssign := HoursOfWork
						if pRequest.IsHoursPerDay {
							hoursAssign = pRequest.HoursPerDay
						}
						breakdownAssig[day.String()] = hoursAssign
						totalHoursAssig = totalHoursAssig - hoursAssign
					}
				}
			}
			// If total hours assign is greater than zero it means that hours and the range is not met.
			if totalHoursAssig > 0 {
				response.Message = util.Concatenate("Total hours does not meet range. (Saturdays and Sundays should not have hours, maximum hours per day is " + strconv.FormatFloat(HoursOfWork, 'f', -1, 64) + " hours, according to the number of days this value is the maximum allowable)")
				response.Project = nil
				response.Status = "Error"
				return &response
			}

			log.Debug("breakdownAssig", breakdownAssig)

			isValidAssig := true
			messageValidation := util.Concatenate("The allocation of hours exceeds the limit of ", strconv.FormatFloat(HoursOfWork, 'f', -1, 64), " hours per day. * ")
			for day := time.Unix(startDateInt, 0); day.Unix() <= time.Unix(endDateInt, 0).Unix(); day = day.AddDate(0, 0, 1) {
				totalHours := breakdown[day.String()] + breakdownAssig[day.String()]
				if totalHours > HoursOfWork {
					messageValidation = util.Concatenate(messageValidation, strconv.FormatFloat(totalHours, 'f', -1, 64), "Hrs ", day.Format("2006-01-02"), " * ")
					isValidAssig = false
				}
			}

			// If the hours exceed the allowed hours per day
			if !isValidAssig {
				log.Debug(messageValidation)
				response.Message = messageValidation
				response.Project = nil
				response.Status = "Error"
				return &response
			}

			projectResources.StartDate = time.Unix(startDateInt, 0)
			projectResources.EndDate = time.Unix(endDateInt, 0)
			projectResources.Lead = pRequest.Lead
			projectResources.Hours = pRequest.Hours

			//find by resource and project
			projectResourcesExist := dao.GetProjectResourcesById(pRequest.ID)
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

				if !pRequest.IsHoursPerDay {
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
				} else {
					elements := 0
					for day, hours := range breakdownAssig {
						elements++
						timeDay, err := time.Parse(util.LONGFORMAT, day)
						projectResources.StartDate = timeDay
						projectResources.EndDate = timeDay
						projectResources.Hours = hours
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
						if elements == len(breakdownAssig) {
							response := getInsertedResource(id, project, timeResponse)
							if response != nil {
								return response
							}
						}
					}
				}

			}

		} else {
			message := "Resource doesn't exist, plese create it"
			log.Error(message)
			response.Message = message
			response.Status = "Error"

			response.Header = util.BuildHeaderResponse(timeResponse)

			return &response
		}
	}
	message = "Project doesn't exist, plese create it"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func getInsertedResource(pIdResProject int, pProject *DOMAIN.Project, pTimeResponse time.Time) *DOMAIN.SetResourceToProjectRS {
	response := DOMAIN.SetResourceToProjectRS{}
	// Get ProjectResources inserted
	projectResourceInserted := dao.GetProjectResourcesById(pIdResProject)
	if projectResourceInserted != nil {
		// Get all resources to this project
		resourcesOfProject := dao.GetProjectResourcesByProjectId(pProject.ID)
		// Mapping resources in the project of the response
		lead := dao.MappingResourcesInAProject(pProject, resourcesOfProject)
		pProject.Lead = lead
		response.Project = pProject

		response.Header = util.BuildHeaderResponse(pTimeResponse)

		response.Status = "OK"

		return &response
	}
	return nil
}

func DeleteResourceToProject(pRequest *DOMAIN.DeleteResourceToProjectRQ) *DOMAIN.DeleteResourceToProjectRS {
	timeResponse := time.Now()
	response := DOMAIN.DeleteResourceToProjectRS{}
	for index, id := range pRequest.IDs {
		projectResource := dao.GetProjectResourcesById(id)
		if projectResource != nil {
			// Delete in DB
			rowsDeleted, err := dao.DeleteProjectResources(projectResource.ID)
			if err != nil || rowsDeleted <= 0 {
				message := "ProjectResource wasn't delete"
				log.Error(message)
				response.Message = message
				response.Status = "Error"
				return &response
			}

			response.IDs = append(response.IDs, projectResource.ID)
			if index == len(pRequest.IDs)-1 {
				response.Status = "OK"

				response.Header = util.BuildHeaderResponse(timeResponse)

				return &response
			}
		}
	}
	message := "ResourceSkill wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

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

		for _, project := range projects {
			if project.LeaderID != nil {
				resource := dao.GetResourceById(*project.LeaderID)
				if resource != nil {
					project.Lead = resource.Name + " " + resource.LastName
				}
			}
		}

		response.Projects = projects
		// Create response
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}
	message = "Projects wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

func ContainsProjectResource(a []*DOMAIN.ProjectResources, x int) (bool, int) {
	for index, n := range a {
		if x == n.ProjectId {
			return true, index
		}
	}
	return false, 0
}

//BuildResourceResponse Build and return an Slice of Resource structs
func BuildResourcesToProjectsResponse(projectResources []*DOMAIN.ProjectResources) []*DOMAIN.ProjectResources {

	projectResourcesResponse := []*DOMAIN.ProjectResources{}

	for _, element := range projectResources {

		// ckeck if the resource is duplicated and takes the index
		exists, index := ContainsProjectResource(projectResourcesResponse, element.ProjectId)
		//validate it if the resource is duplicated , if it is duplicated
		if !exists {
			//Instance ProjectResources structures and TaskDetail
			resourcestruct := &DOMAIN.ProjectResources{}
			taskDetail := &DOMAIN.TaskDetail{}

			//Assigns values to each attribute of the instantiated structure
			resourcestruct.ID = element.ID
			resourcestruct.ProjectId = element.ProjectId
			resourcestruct.ResourceId = element.ResourceId
			resourcestruct.ProjectName = element.ProjectName
			resourcestruct.ResourceName = element.ResourceName
			resourcestruct.StartDate = element.StartDate
			resourcestruct.EndDate = element.EndDate
			resourcestruct.Lead = element.Lead
			resourcestruct.Hours = element.Hours
			resourcestruct.Task = element.Task
			resourcestruct.AssignatedBy = sql.NullInt64{Int64: int64(0), Valid: true}
			resourcestruct.Deliverable = ""
			resourcestruct.Requirements = ""
			resourcestruct.Priority = ""
			resourcestruct.AdditionalComments = ""
			resourcestruct.AssignatedByName = ""
			resourcestruct.AssignatedByLastName = ""
			//resourcesToProjectsRS.TotalHours += resourcestruct.Hours
			//resourcestruct.TotalHours += resourcestruct.Hours
			//Assigns values to each attribute of the instantiated structure
			taskDetail.StartDate = element.StartDate
			taskDetail.EndDate = element.EndDate
			taskDetail.Hours = element.Hours
			taskDetail.Task = element.Task
			taskDetail.AssignatedBy = sql.NullInt64{Int64: int64(0), Valid: true}
			taskDetail.Deliverable = element.Deliverable
			taskDetail.Requirements = element.Requirements
			taskDetail.Priority = element.Priority
			taskDetail.AdditionalComments = element.AdditionalComments
			taskDetail.AssignatedByName = element.AssignatedByName
			taskDetail.AssignatedByLastName = element.AssignatedByLastName
			//Add the structure to the slice of structures
			resourcestruct.TaskDetail = append(resourcestruct.TaskDetail, taskDetail)

			//Add the structure to the slice of structures included ResourceTypes
			projectResourcesResponse = append(projectResourcesResponse, resourcestruct)

			taskDetail = nil
			resourcestruct = nil
		} else {
			//Instance ProjectResources structures and TaskDetail
			resourcestruct := &DOMAIN.ProjectResources{}
			//Instance taskDetail structure
			taskDetail := &DOMAIN.TaskDetail{}

			//Assigns values to each attribute of the instantiated structure
			resourcestruct.ID = element.ID
			resourcestruct.ProjectId = element.ProjectId
			resourcestruct.ResourceId = element.ResourceId
			resourcestruct.ProjectName = element.ProjectName
			resourcestruct.ResourceName = element.ResourceName
			resourcestruct.StartDate = element.StartDate
			resourcestruct.EndDate = element.EndDate
			resourcestruct.Lead = element.Lead
			resourcestruct.Hours = element.Hours
			resourcestruct.Task = element.Task
			resourcestruct.AssignatedBy = sql.NullInt64{Int64: int64(0), Valid: true}
			resourcestruct.Deliverable = ""
			resourcestruct.Requirements = ""
			resourcestruct.Priority = ""
			resourcestruct.AdditionalComments = ""
			resourcestruct.AssignatedByName = ""
			resourcestruct.AssignatedByLastName = ""
			//Assigns values to each attribute of the instantiated structure
			taskDetail.StartDate = element.StartDate
			taskDetail.EndDate = element.EndDate
			taskDetail.Hours = element.Hours
			taskDetail.Task = element.Task
			taskDetail.AssignatedBy = element.AssignatedBy
			taskDetail.Deliverable = element.Deliverable
			taskDetail.Requirements = element.Requirements
			taskDetail.Priority = element.Priority
			taskDetail.AdditionalComments = element.AdditionalComments
			taskDetail.AssignatedByName = element.AssignatedByName
			taskDetail.AssignatedByLastName = element.AssignatedByLastName
			projectResourcesResponse[index].Hours += element.Hours
			//projectResourcesResponse[index].TotalHours += projectResourcesResponse[index].Hours

			//Add the structure to the slice of structures included ResourceTypes
			projectResourcesResponse = append(projectResourcesResponse, resourcestruct)
			//Add the structure to the slice of structures
			projectResourcesResponse[index].TaskDetail = append(projectResourcesResponse[index].TaskDetail, taskDetail)
			taskDetail = nil
		}
	}
	return projectResourcesResponse
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

	//responseTime := time.Now().Sub(timeResponse)
	//fmt.Println("GetProjectsResourcesByFilters time:", responseTime.String())

	if len(projectsResources) == 0 && filterString == "" {
		projectsResources = dao.GetAllProjectResources()
	}

	projectsResourcesResponse := BuildResourcesToProjectsResponse(projectsResources)
	var tempHour float64
	for _, element := range projectsResourcesResponse {
		if element.TaskDetail != nil {
			tempHour += element.Hours
		}
	}
	response.TotalHours = 45 - tempHour
	/*
		requestProjects := DOMAIN.GetProjectsRQ{}
		requestProjects.StartDate = pRequest.StartDate
		requestProjects.EndDate = pRequest.EndDate
		requestProjects.Enabled = newTrue()

		//TODO filter in query enabled projects.
		responseProjects := GetProjects(&requestProjects)
		response.Projects = responseProjects.Projects*/

	response.Projects = getFilterProject(pRequest.StartDate, pRequest.EndDate, pRequest.Enabled)

	/*for _, project := range responseProjects.Projects {
		// only return projects enabled
		if project.Enabled {
			response.Projects = append(response.Projects, project)
		}
	}*/
	//responseTime = time.Now().Sub(timeResponse)
	//fmt.Println("GetProjects.enabled time:", responseTime.String())

	/*requestResources := DOMAIN.GetResourcesRQ{}
	requestResources.Enabled = newTrue()
	responseResources := GetResources(&requestResources)
	response.Resources = responseResources.Resources
	*/
	response.Resources = getFilterResource()
	/*for _, resource := range responseResources.Resources {
		// only return resources enabled
		if resource.Enabled {
			response.Resources = append(response.Resources, resource)
		}
	}*/
	//responseTime = time.Now().Sub(timeResponse)
	//fmt.Println("GetResourcesRQ.enabled time:", responseTime.String())

	//if projectsResources != nil && len(projectsResources) > 0 {

	startDate, _ := time.Parse("2006-01-02", pRequest.StartDate)
	endDate, _ := time.Parse("2006-01-02", pRequest.EndDate)

	// breakdown exist assignation map[resourceID]map[day]hours
	breakdown := make(map[int]map[string]float64)

	for _, assignation := range projectsResources {

		if breakdown[assignation.ResourceId] == nil {
			breakdown[assignation.ResourceId] = make(map[string]float64)
		}
		totalHours := assignation.Hours

		for day := assignation.StartDate; day.Unix() <= assignation.EndDate.Unix(); day = day.AddDate(0, 0, 1) {
			if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
				//if startDate.Unix() <= day.Unix() && endDate.Unix() >= day.Unix() {
				if totalHours > 0 && totalHours <= HoursOfWork {
					breakdown[assignation.ResourceId][day.Format("2006-01-02")] += totalHours
					break
				} else {
					breakdown[assignation.ResourceId][day.Format("2006-01-02")] += HoursOfWork
					totalHours = totalHours - HoursOfWork
				}
				//}
			}
		}
	}
	//responseTime = time.Now().Sub(timeResponse)
	//fmt.Println("projectsResources.breakdown time:", responseTime.String())
	log.Debug("breakdownGet", breakdown)

	// Calculate the available hours according to hours assignation
	availBreakdown := make(map[int]map[string]float64)

	for _, resource := range response.Resources {

		for day := startDate; day.Unix() <= endDate.Unix(); day = day.AddDate(0, 0, 1) {
			if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
				_, exist := breakdown[resource.ID]

				if exist {
					availHours := HoursOfWork - breakdown[resource.ID][day.Format("2006-01-02")]
					if availHours > 0 {
						if availBreakdown[resource.ID] == nil {
							availBreakdown[resource.ID] = make(map[string]float64)
						}
						availBreakdown[resource.ID][day.Format("2006-01-02")] = availHours
					}
				} else {
					if availBreakdown[resource.ID] == nil {
						availBreakdown[resource.ID] = make(map[string]float64)
					}
					availBreakdown[resource.ID][day.Format("2006-01-02")] = HoursOfWork
				}
			}
		}
	}
	//responseTime = time.Now().Sub(timeResponse)
	//fmt.Println("Response.loop time:", responseTime.String())

	response.AvailBreakdown = availBreakdown
	//
	availBreakdownPerRange := make(map[int]*DOMAIN.ResourceAvailabilityInformation)
	for resourceId, mapHourPerDate := range response.AvailBreakdown {

		resourceAvailabilityInformation := DOMAIN.ResourceAvailabilityInformation{}
		var totalHours float64
		rangesPerDay := []*DOMAIN.RangeDatesAvailability{}
		rangePerDay := new(DOMAIN.RangeDatesAvailability)

		for day := startDate; day.Unix() <= endDate.AddDate(0, 0, 1).Unix(); day = day.AddDate(0, 0, 1) {
			if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
				if rangePerDay.StartDate == "" {
					rangePerDay.StartDate = day.Format("2006-01-02")
				}
				if rangePerDay.EndDate == "" {
					rangePerDay.EndDate = day.Format("2006-01-02")
				}
				availHours, exist := mapHourPerDate[day.Format("2006-01-02")]
				if exist {
					if availHours > 0 {
						rangePerDay.EndDate = day.Format("2006-01-02")
						rangePerDay.Hours += availHours
					}
				} else {
					if rangePerDay.Hours > 0 {
						copyRangePerDay := *rangePerDay
						totalHours += copyRangePerDay.Hours
						rangesPerDay = append(rangesPerDay, &copyRangePerDay)
						rangePerDay = new(DOMAIN.RangeDatesAvailability)
					} else {
						rangePerDay = new(DOMAIN.RangeDatesAvailability)
					}
				}
			} else if day.Unix() > endDate.Unix() && rangePerDay.Hours > 0 {
				copyRangePerDay := *rangePerDay
				totalHours += copyRangePerDay.Hours
				rangesPerDay = append(rangesPerDay, &copyRangePerDay)
				rangePerDay = new(DOMAIN.RangeDatesAvailability)
			}
		}

		resourceAvailabilityInformation.ListOfRange = rangesPerDay
		resourceAvailabilityInformation.TotalHours = totalHours
		availBreakdownPerRange[resourceId] = &resourceAvailabilityInformation
	}

	log.Debug("AvailBreakdownPerRange", availBreakdownPerRange)
	response.AvailBreakdownPerRange = availBreakdownPerRange
	//

	response.ResourcesToProjects = projectsResourcesResponse

	// Set value epsilon
	response.EpsilonValue = EpsilonValue

	// Create response
	response.Status = "OK"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
	/*}

	message = "Resources To Projects wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header =  util.BuildHeaderResponse(timeResponse)

	return &response
	*/
}

func newTrue() *bool {
	b := true
	return &b
}

func getFilterResource() []*DOMAIN.Resource {
	requestResources := DOMAIN.GetResourcesRQ{}
	requestResources.Enabled = newTrue()
	if EnabledResources == nil || len(EnabledResources) == 0 {
		responseResources := GetResources(&requestResources)
		EnabledResources = responseResources.Resources
		return responseResources.Resources
	}
	return EnabledResources
}

var EnabledResources = []*DOMAIN.Resource{}

func getFilterProject(pStartDate, pEndDate string, pEnabled bool) []*DOMAIN.Project {
	requestProjects := DOMAIN.GetProjectsRQ{}
	requestProjects.StartDate = pStartDate
	requestProjects.EndDate = pEndDate
	if pEnabled {
		requestProjects.Enabled = &pEnabled
	}

	//TODO filter in query enabled projects.
	responseProjects := GetProjects(&requestProjects)
	return responseProjects.Projects
}

func GetProjectsByResource(pRequest *DOMAIN.GetResourcesToProjectsRQ) *DOMAIN.GetResourcesToProjectsRS {
	timeResponse := time.Now()
	response := DOMAIN.GetResourcesToProjectsRS{}

	filters := util.MappingFiltersProjectResource(pRequest)
	projectsResources, filterString := dao.GetProjectsResourcesByFilters(filters, pRequest.StartDate, pRequest.EndDate, pRequest.Lead)

	if len(projectsResources) == 0 && filterString == "" {
		projectsResources = dao.GetAllProjectResources()
	}

	//fmt.Println("ENVIO PERICION : pRequest.ResourceId ->")
	//fmt.Println(pRequest.ResourceId)
	response.Projects = getDistintProjects(pRequest.ResourceId)
	response.Resources = getFilterResource()

	startDate, _ := time.Parse("2006-01-02", pRequest.StartDate)
	endDate, _ := time.Parse("2006-01-02", pRequest.EndDate)

	// breakdown exist assignation map[resourceID]map[day]hours
	breakdown := make(map[int]map[string]float64)

	for _, assignation := range projectsResources {

		if breakdown[assignation.ResourceId] == nil {
			breakdown[assignation.ResourceId] = make(map[string]float64)
		}
		totalHours := assignation.Hours

		for day := assignation.StartDate; day.Unix() <= assignation.EndDate.Unix(); day = day.AddDate(0, 0, 1) {
			if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
				//if startDate.Unix() <= day.Unix() && endDate.Unix() >= day.Unix() {
				if totalHours > 0 && totalHours <= HoursOfWork {
					breakdown[assignation.ResourceId][day.Format("2006-01-02")] += totalHours
					break
				} else {
					breakdown[assignation.ResourceId][day.Format("2006-01-02")] += HoursOfWork
					totalHours = totalHours - HoursOfWork
				}

			}
		}
	}
	log.Debug("breakdownGet", breakdown)

	// Calculate the available hours according to hours assignation
	availBreakdown := make(map[int]map[string]float64)

	for _, resource := range response.Resources {

		for day := startDate; day.Unix() <= endDate.Unix(); day = day.AddDate(0, 0, 1) {
			if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
				_, exist := breakdown[resource.ID]

				if exist {
					availHours := HoursOfWork - breakdown[resource.ID][day.Format("2006-01-02")]
					if availHours > 0 {
						if availBreakdown[resource.ID] == nil {
							availBreakdown[resource.ID] = make(map[string]float64)
						}
						availBreakdown[resource.ID][day.Format("2006-01-02")] = availHours
					}
				} else {
					if availBreakdown[resource.ID] == nil {
						availBreakdown[resource.ID] = make(map[string]float64)
					}
					availBreakdown[resource.ID][day.Format("2006-01-02")] = HoursOfWork
				}
			}
		}
	}

	response.AvailBreakdown = availBreakdown
	//
	availBreakdownPerRange := make(map[int]*DOMAIN.ResourceAvailabilityInformation)
	for resourceId, mapHourPerDate := range response.AvailBreakdown {

		resourceAvailabilityInformation := DOMAIN.ResourceAvailabilityInformation{}
		var totalHours float64
		rangesPerDay := []*DOMAIN.RangeDatesAvailability{}
		rangePerDay := new(DOMAIN.RangeDatesAvailability)

		for day := startDate; day.Unix() <= endDate.AddDate(0, 0, 1).Unix(); day = day.AddDate(0, 0, 1) {
			if day.Weekday() != time.Saturday && day.Weekday() != time.Sunday {
				if rangePerDay.StartDate == "" {
					rangePerDay.StartDate = day.Format("2006-01-02")
				}
				if rangePerDay.EndDate == "" {
					rangePerDay.EndDate = day.Format("2006-01-02")
				}
				availHours, exist := mapHourPerDate[day.Format("2006-01-02")]
				if exist {
					if availHours > 0 {
						rangePerDay.EndDate = day.Format("2006-01-02")
						rangePerDay.Hours += availHours
					}
				} else {
					if rangePerDay.Hours > 0 {
						copyRangePerDay := *rangePerDay
						totalHours += copyRangePerDay.Hours
						rangesPerDay = append(rangesPerDay, &copyRangePerDay)
						rangePerDay = new(DOMAIN.RangeDatesAvailability)
					} else {
						rangePerDay = new(DOMAIN.RangeDatesAvailability)
					}
				}
			} else if day.Unix() > endDate.Unix() && rangePerDay.Hours > 0 {
				copyRangePerDay := *rangePerDay
				totalHours += copyRangePerDay.Hours
				rangesPerDay = append(rangesPerDay, &copyRangePerDay)
				rangePerDay = new(DOMAIN.RangeDatesAvailability)
			}
		}

		resourceAvailabilityInformation.ListOfRange = rangesPerDay
		resourceAvailabilityInformation.TotalHours = totalHours
		availBreakdownPerRange[resourceId] = &resourceAvailabilityInformation
	}

	log.Debug("AvailBreakdownPerRange", availBreakdownPerRange)
	response.AvailBreakdownPerRange = availBreakdownPerRange
	//

	response.ResourcesToProjects = projectsResources

	// Set value epsilon
	response.EpsilonValue = EpsilonValue

	// Create response
	response.Status = "OK"

	response.Header = util.BuildHeaderResponse(timeResponse)
	return &response

}

func getDistintProjects(pResourceId int) []*DOMAIN.Project {
	projects, _ := dao.GetProjectsByResourceId(pResourceId)
	return projects
}
