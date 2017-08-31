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
	project := util.MappingCreateProject(pRequest)
	// Create response
	response := DOMAIN.CreateProjectRS{}
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
	response.Status = "ERROR"

	header := new(DOMAIN.CreateProjectRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header
	return &response
}

func UpdateProject(pRequest *DOMAIN.UpdateProjectRQ) *DOMAIN.UpdateProjectRS {
	/*project := util.MappingCreateProject(pRequest)
	// Save in DB
	id, err := dao.AddProject(project)*/
	// Create response
	response := DOMAIN.UpdateProjectRS{}
	/*if err != nil || id != 1 {
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
	response.Status = "OK"*/
	return &response
}

func DeleteProject(pRequest *DOMAIN.DeleteProjectRQ) *DOMAIN.DeleteProjectRS {
	/*project := util.MappingCreateProject(pRequest)
	// Save in DB
	id, err := dao.AddProject(project)*/
	// Create response
	response := DOMAIN.DeleteProjectRS{}
	/*if err != nil || id != 1 {
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
	response.Status = "OK"*/
	return &response
}
