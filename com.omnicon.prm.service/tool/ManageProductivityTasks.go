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

	productivityTasks := util.MappingProductivityTasksRQ(pRequest)
	_, err := dao.AddProductivityTasks(productivityTasks)
	// Create response
	response := DOMAIN.ProductivityTasksRS{}
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
		if pRequest.Scheduled != 0 {
			oldProductivityTasks.Scheduled = pRequest.Scheduled
		}
		if pRequest.Progress != 0 {
			oldProductivityTasks.Progress = pRequest.Progress
		}

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
