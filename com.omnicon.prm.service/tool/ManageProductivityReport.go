package tool

import (
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

/**
* Function to create a new ProductivityReport from ProductivityReportRQ
 */
func CreateProductivityReport(pRequest *DOMAIN.ProductivityReportRQ) *DOMAIN.ProductivityReportRS {
	timeResponse := time.Now()

	// Create response
	response := DOMAIN.ProductivityReportRS{}

	report := dao.GetProductivityReportByTaskIDAndResourceID(pRequest.TaskID, pRequest.ResourceID)
	if report != nil {
		message := "ProductivityReport already exist"
		log.Error(message)
		response.Message = message
		response.Status = "Error"
		return &response
	}

	productivityReport := util.MappingProductivityReportRQ(pRequest)
	_, err := dao.AddProductivityReport(productivityReport)

	if err != nil {
		message := "ProductivityReport wasn't insert"
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
* Get all elements of productivityReport from the request values
 */
func GetProductivityReport(pRequest *DOMAIN.ProductivityReportRQ) *DOMAIN.ProductivityReportRS {
	timeResponse := time.Now()
	response := DOMAIN.ProductivityReportRS{}
	filters := util.MappingFiltersProductivityReport(pRequest)
	productivityReport, filterString := dao.GetProductivityReportByFilters(filters)

	if len(productivityReport) == 0 && filterString == "" {
		productivityReport = dao.GetAllProductivityReport()
	}

	if productivityReport != nil && len(productivityReport) > 0 {

		response.ProductivityReport = productivityReport
		// Create response
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "ProductivityReport wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to update a productivityReport from ProductivityReportRQ
 */
func UpdateProductivityReport(pRequest *DOMAIN.ProductivityReportRQ) *DOMAIN.ProductivityReportRS {
	timeResponse := time.Now()
	response := DOMAIN.ProductivityReportRS{}
	oldProductivityReport := dao.GetProductivityReportByID(pRequest.ID)
	if oldProductivityReport != nil {

		if pRequest.TaskID != 0 {
			oldProductivityReport.TaskID = pRequest.TaskID
		}
		if pRequest.ResourceID != 0 {
			oldProductivityReport.ResourceID = pRequest.ResourceID
		}
		if pRequest.Hours != 0 {
			oldProductivityReport.Hours = pRequest.Hours
		}

		// Save in DB
		rowsUpdated, err := dao.UpdateProductivityReport(oldProductivityReport)
		if err != nil || rowsUpdated <= 0 {
			message := "ProductivityReport wasn't update"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "ProductivityReport wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to delete a productivityReport from ProductivityReportRQ
 */
func DeleteProductivityReport(pRequest *DOMAIN.ProductivityReportRQ) *DOMAIN.ProductivityReportRS {
	timeResponse := time.Now()
	response := DOMAIN.ProductivityReportRS{}
	productivityReportToDelete := dao.GetProductivityReportByID(pRequest.ID)
	if productivityReportToDelete != nil {

		// Delete in DB
		rowsDeleted, err := dao.DeleteProductivityReport(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "ProductivityReport wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}
	message := "ProductivityReport wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}
