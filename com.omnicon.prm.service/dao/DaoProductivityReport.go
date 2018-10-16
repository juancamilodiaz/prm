package dao

import (
	"bytes"
	"strconv"

	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

//var sessionDB sqlbuilder.Database

/**
*	Name : getProductivityReportCollection
*	Return: db.Collection
*	Description: Get table ProductivityReport in a session
 */
func getProductivityReportCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table ProductivityReport in the session
	if session != nil {
		return session.Collection("ProductivityReport")
	} else {
		return nil
	}
}

/**
*	Name : GetAllProductivityReport
*	Return: []*DOMAIN.ProductivityReport
*	Description: Get all productivityReport in a ProductivityReport table
 */
func GetAllProductivityReport() []*DOMAIN.ProductivityReport {
	// Slice to keep all ProductivityReport
	var productivityReport []*DOMAIN.ProductivityReport
	if getProductivityReportCollection() != nil {

		// Add all ProductivityReport in productivityReport variable
		err := getProductivityReportCollection().Find().All(&productivityReport)

		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Error(err)
		}
	}

	return productivityReport
}

/**
*	Name : GetProductivityReportByID
*	Params: pID
*	Return: *DOMAIN.ProductivityReport
*	Description: Get a ProductivityReport by ID in a ProductivityReport table
 */
func GetProductivityReportByID(pID int) *DOMAIN.ProductivityReport {
	// ProductivityReport structure
	productivityReport := DOMAIN.ProductivityReport{}
	if getProductivityReportCollection() != nil {
		// Add in ProductivityReport variable, the ProductivityReport where ID is the same that the param
		res := getProductivityReportCollection().Find(db.Cond{"id": pID})
		log.Debug("find ProductivityReport by ID:", pID)
		// Close session when ends the method
		defer session.Close()
		err := res.One(&productivityReport)
		if err != nil {
			log.Error(err)
			return nil
		}
		log.Debug("Result:", productivityReport)
	}
	return &productivityReport
}

/**
*	Name : GetProductivityReportByTaskID
*	Params: pProjectID
*	Return: *DOMAIN.ProductivityReport
*	Description: Get a ProductivityReport by task ID in a ProductivityReport table
 */
func GetProductivityReportByTaskID(pTaskID int) []*DOMAIN.ProductivityReport {
	// ProductivityReport structure
	productivityReport := []*DOMAIN.ProductivityReport{}
	if getProductivityReportCollection() != nil {
		// Add in ProductivityReport variable, the ProductivityReport where ID is the same that the param
		res := getProductivityReportCollection().Find().Where("task_id = ?", pTaskID)
		// Close session when ends the method
		defer session.Close()
		err := res.All(&productivityReport)
		if err != nil {
			log.Error(err)
			return nil
		}
	}
	return productivityReport
}

/**
*	Name : GetProductivityReportByResourceID
*	Params: pProjectID
*	Return: *DOMAIN.ProductivityReport
*	Description: Get a ProductivityReport by resource ID in a ProductivityReport table
 */
func GetProductivityReportByResourceID(pResourceID int) []*DOMAIN.ProductivityReport {
	// ProductivityReport structure
	productivityReport := []*DOMAIN.ProductivityReport{}
	if getProductivityReportCollection() != nil {

		// Add in ProductivityReport variable, the ProductivityReport where ID is the same that the param
		res := getProductivityReportCollection().Find().Where("resource_id = ?", pResourceID)
		// Close session when ends the method
		defer session.Close()
		err := res.All(&productivityReport)
		if err != nil {
			log.Error(err)
			return nil
		}
	}
	return productivityReport
}

/**
*	Name : GetProductivityReportByTaskIDAndResourceID
*	Params: pProjectID
*	Return: *DOMAIN.ProductivityReport
*	Description: Get a ProductivityReport by task ID and resource ID in a ProductivityReport table
 */
func GetProductivityReportByTaskIDAndResourceID(pTaskID, pResourceID int) []*DOMAIN.ProductivityReport {
	// ProductivityReport structure
	productivityReport := []*DOMAIN.ProductivityReport{}
	if getProductivityReportCollection() != nil {
		// Add in ProductivityReport variable, the ProductivityReport where ID is the same that the param
		res := getProductivityReportCollection().Find().Where("task_id = ?", pTaskID).And("resource_id = ?", pResourceID)
		// Close session when ends the method
		defer session.Close()
		err := res.All(&productivityReport)
		if err != nil {
			log.Error(err)
			return nil
		}
	}
	return productivityReport
}

/**
*	Name : AddProductivityReport
*	Params: pProductivityReport
*	Return: int, error
*	Description: Add ProductivityReport in DB
 */
func AddProductivityReport(pProductivityReport *DOMAIN.ProductivityReport) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Insert ProductivityReport in DB
		res, err := session.InsertInto("ProductivityReport").Columns(
			"task_id", "resource_id", "hours", "hours_billable").Values(
			pProductivityReport.TaskID, pProductivityReport.ResourceID, pProductivityReport.Hours, pProductivityReport.HoursBillable).Exec()
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
*	Name : UpdateProductivityReport
*	Params: pProductivityReport
*	Return: int, error
*	Description: Update productivityReport in DB
 */
func UpdateProductivityReport(pProductivityReport *DOMAIN.ProductivityReport) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Update ProductivityReport in DB
		q := session.Update("ProductivityReport").Set("hours = ?, hours_billable = ?",
			pProductivityReport.Hours, pProductivityReport.HoursBillable).Where("id = ?", pProductivityReport.ID)
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
*	Name : DeleteProductivityReport
*	Params: pProductivityReportId
*	Return: int, error
*	Description: Delete ProductivityReport in DB
 */
func DeleteProductivityReport(pID int) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Delete productivityReport in DB
		q := session.DeleteFrom("ProductivityReport").Where("id", pID)
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
*	Name : GetProductivityReportByFilters
*	Params: pName
*	Return: []*DOMAIN.ProductivityReport
*	Description: Get a slice of productivityReport from productivityReport table
 */
func GetProductivityReportByFilters(pProductivityReportFilters *DOMAIN.ProductivityReport) ([]*DOMAIN.ProductivityReport, string) {
	// Slice to keep all productivityReport
	productivityReport := []*DOMAIN.ProductivityReport{}
	var stringResponse string
	if getProductivityReportCollection() != nil {
		// Filter productivityReport
		result := getProductivityReportCollection().Find()

		// Close session when ends the method
		defer session.Close()

		var filters bytes.Buffer
		if pProductivityReportFilters.ID != 0 {
			filters.WriteString("id = '")
			filters.WriteString(strconv.Itoa(pProductivityReportFilters.ID))
			filters.WriteString("'")
		}
		if pProductivityReportFilters.TaskID != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("task_id = '")
			filters.WriteString(strconv.Itoa(pProductivityReportFilters.TaskID))
			filters.WriteString("'")
		}
		if pProductivityReportFilters.ResourceID != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("resource_id = '")
			filters.WriteString(strconv.Itoa(pProductivityReportFilters.ResourceID))
			filters.WriteString("'")
		}

		if filters.String() != "" {
			// Add all productivityReport in productivityReport variable
			err := result.Where(filters.String()).All(&productivityReport)
			if err != nil {
				log.Error(err)
			}
		}
		stringResponse = filters.String()

	}
	return productivityReport, stringResponse
}
