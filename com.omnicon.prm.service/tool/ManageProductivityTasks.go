package tool

import (
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

/**
* Function to create a new ProductivityTasks from ProductivityTasksRQ
 */
func CreateProductivityTasks(pRequest *DOMAIN.ProductivityTasksRQ) *DOMAIN.ProductivityTasksRS {
	timeResponse := time.Now()

	// Create response
	response := DOMAIN.ProductivityTasksRS{}

	// Validations
	errorMessage := validationRequest(pRequest.Name, pRequest.Scheduled, pRequest.Progress)
	if errorMessage != "" {
		response.Message = errorMessage
		response.Status = "Error"
		return &response
	}

	productivityTasks := util.MappingProductivityTasksRQ(pRequest)
	_, err := dao.AddProductivityTasks(productivityTasks)

	if err != nil {
		message := "ProductivityTasks wasn't insert"
		log.Error(message)
		response.Message = message
		response.Status = "Error"
		return &response
	}
	response.Status = "OK"
	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/*
* Get all elements of productivityTasks from the request values
 */
func GetProductivityTasks(pRequest *DOMAIN.ProductivityTasksRQ) *DOMAIN.ProductivityTasksRS {
	timeResponse := time.Now()
	response := DOMAIN.ProductivityTasksRS{}
	filters := util.MappingFiltersProductivityTasks(pRequest)
	productivityTasks, filterString := dao.GetProductivityTasksByFilters(filters)

	if len(productivityTasks) == 0 && filterString == "" {
		productivityTasks = dao.GetAllProductivityTasks()
	}

	if productivityTasks != nil && len(productivityTasks) > 0 {

		// Create list of reports
		var listResourceReports map[int]*DOMAIN.ResourceReport
		for _, task := range productivityTasks {
			reports := dao.GetProductivityReportByTaskID(task.ID)
			for _, report := range reports {
				if listResourceReports == nil {
					listResourceReports = make(map[int]*DOMAIN.ResourceReport)
				}
				if listResourceReports[report.ResourceID] == nil {
					listResourceReports[report.ResourceID] = new(DOMAIN.ResourceReport)
					resource := dao.GetResourceById(report.ResourceID)
					if resource != nil {
						listResourceReports[report.ResourceID].ResourceID = resource.ID
						listResourceReports[report.ResourceID].NameResource = resource.Name + " " + resource.LastName
						if listResourceReports[report.ResourceID].ReportByTask == nil {
							listResourceReports[report.ResourceID].ReportByTask = make(map[int]*DOMAIN.Report)
						}
					}
				}
				listResourceReports[report.ResourceID].ReportByTask[report.TaskID] = new(DOMAIN.Report)
				listResourceReports[report.ResourceID].ReportByTask[report.TaskID].ID = report.ID
				listResourceReports[report.ResourceID].ReportByTask[report.TaskID].Hours = report.Hours
				listResourceReports[report.ResourceID].ReportByTask[report.TaskID].HoursBillable = report.HoursBillable
			}
		}

		// Set of report resources
		response.ResourceReports = listResourceReports

		response.ProductivityTasks = productivityTasks
		// Create response
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "ProductivityTasks wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to update a productivityTasks from ProductivityTasksRQ
 */
func UpdateProductivityTasks(pRequest *DOMAIN.ProductivityTasksRQ) *DOMAIN.ProductivityTasksRS {
	timeResponse := time.Now()

	response := DOMAIN.ProductivityTasksRS{}

	// Validations
	errorMessage := validationRequest(pRequest.Name, pRequest.Scheduled, pRequest.Progress)
	if errorMessage != "" {
		response.Message = errorMessage
		response.Status = "Error"
		return &response
	}

	oldProductivityTasks := dao.GetProductivityTasksByID(pRequest.ID)
	if oldProductivityTasks != nil {

		if pRequest.ProjectID != 0 {
			oldProductivityTasks.ProjectID = pRequest.ProjectID
		}
		if pRequest.Name != "" {
			oldProductivityTasks.Name = pRequest.Name
		}
		if pRequest.TotalExecute != 0 {
			oldProductivityTasks.TotalExecute = pRequest.TotalExecute
		}
		if pRequest.TotalBillable != 0 {
			oldProductivityTasks.TotalBillable = pRequest.TotalBillable
		}
		if pRequest.Scheduled != 0 {
			oldProductivityTasks.Scheduled = pRequest.Scheduled
		}
		if pRequest.Progress != 0 {
			oldProductivityTasks.Progress = pRequest.Progress
		}
		oldProductivityTasks.IsOutOfScope = pRequest.IsOutOfScope

		// Save in DB
		rowsUpdated, err := dao.UpdateProductivityTasks(oldProductivityTasks)
		if err != nil || rowsUpdated <= 0 {
			message := "ProductivityTasks wasn't update"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "ProductivityTasks wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to delete a productivityTasks from ProductivityTasksRQ
 */
func DeleteProductivityTasks(pRequest *DOMAIN.ProductivityTasksRQ) *DOMAIN.ProductivityTasksRS {
	timeResponse := time.Now()
	response := DOMAIN.ProductivityTasksRS{}
	productivityTasksToDelete := dao.GetProductivityTasksByID(pRequest.ID)
	if productivityTasksToDelete != nil {

		// Delete productivityTasks associations
		reports := dao.GetProductivityReportByTaskID(pRequest.ID)
		for _, report := range reports {
			_, err := dao.DeleteProductivityReport(report.ID)
			if err != nil {
				log.Error("Failed to delete productivity report")
			}
		}

		// Delete in DB
		rowsDeleted, err := dao.DeleteProductivityTasks(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "ProductivityTasks wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}
	message := "ProductivityTasks wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

// function of validation request
func validationRequest(pName string, pScheduled, pProgress float64) string {
	// Validations
	if pName == "" {
		message := "Name can not empty"
		log.Error(message)
		return message
	}
	if pScheduled <= 0 {
		message := "Scheduled can not zero or negative"
		log.Error(message)
		return message
	}
	if pProgress < 0 {
		message := "Progress can not negative"
		log.Error(message)
		return message
	}
	if pProgress > 100 {
		message := "Progress can not exceed 100%"
		log.Error(message)
		return message
	}
	return ""
}
