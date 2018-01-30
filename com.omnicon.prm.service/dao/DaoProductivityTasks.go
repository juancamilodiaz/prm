package dao

import (
	"bytes"
	"strconv"

	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getProductivityTasksCollection
*	Return: db.Collection
*	Description: Get table ProductivityTasks in a session
 */
func getProductivityTasksCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table ProductivityTasks in the session
	return session.Collection("ProductivityTasks")
}

/**
*	Name : GetAllProductivityTasks
*	Return: []*DOMAIN.ProductivityTasks
*	Description: Get all productivityTasks in a ProductivityTasks table
 */
func GetAllProductivityTasks() []*DOMAIN.ProductivityTasks {
	// Slice to keep all ProductivityTasks
	var productivityTasks []*DOMAIN.ProductivityTasks
	// Add all ProductivityTasks in productivityTasks variable
	err := getProductivityTasksCollection().Find().All(&productivityTasks)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return productivityTasks
}

/**
*	Name : GetProductivityTasksByID
*	Params: pID
*	Return: *DOMAIN.ProductivityTasks
*	Description: Get a ProductivityTasks by ID in a ProductivityTasks table
 */
func GetProductivityTasksByID(pID int) *DOMAIN.ProductivityTasks {
	// ProductivityTasks structure
	productivityTasks := DOMAIN.ProductivityTasks{}
	// Add in ProductivityTasks variable, the ProductivityTasks where ID is the same that the param
	res := getProductivityTasksCollection().Find(db.Cond{"id": pID})
	log.Debug("find ProductivityTasks by ID:", pID)
	// Close session when ends the method
	defer session.Close()
	err := res.One(&productivityTasks)
	if err != nil {
		log.Error(err)
		return nil
	}
	log.Debug("Result:", productivityTasks)
	return &productivityTasks
}

/**
*	Name : GetProductivityTasksByProjectId
*	Params: pProjectID
*	Return: *DOMAIN.ProductivityTasks
*	Description: Get a ProductivityTasks by Project ID in a ProductivityTasks table
 */
func GetProductivityTasksByProjectID(pProjectID int) []*DOMAIN.ProductivityTasks {
	// ProductivityTasks structure
	productivityTasks := []*DOMAIN.ProductivityTasks{}
	// Add in ProductivityTasks variable, the ProductivityTasks where ID is the same that the param
	res := getProductivityTasksCollection().Find().Where("project_id = ?", pProjectID)
	// Close session when ends the method
	defer session.Close()
	err := res.All(&productivityTasks)
	if err != nil {
		log.Error(err)
		return nil
	}
	return productivityTasks
}

/**
*	Name : AddProductivityTasks
*	Params: pProductivityTasks
*	Return: int, error
*	Description: Add ProductivityTasks in DB
 */
func AddProductivityTasks(pProductivityTasks *DOMAIN.ProductivityTasks) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert ProductivityTasks in DB
	res, err := session.InsertInto("ProductivityTasks").Columns(
		"project_id", "name", "total_execute", "total_billable", "scheduled", "progress", "is_out_of_scope").Values(
		pProductivityTasks.ProjectID, pProductivityTasks.Name, pProductivityTasks.TotalExecute, pProductivityTasks.TotalBillable, pProductivityTasks.Scheduled, pProductivityTasks.Progress, pProductivityTasks.IsOutOfScope).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return int(insertId), nil
}

/**
*	Name : UpdateProductivityTasks
*	Params: pProductivityTasks
*	Return: int, error
*	Description: Update productivityTasks in DB
 */
func UpdateProductivityTasks(pProductivityTasks *DOMAIN.ProductivityTasks) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update ProductivityTasks in DB
	q := session.Update("ProductivityTasks").Set("name = ?, total_execute = ?, total_billable = ?, scheduled = ?, progress = ?, is_out_of_scope = ?",
		pProductivityTasks.Name, pProductivityTasks.TotalExecute, pProductivityTasks.TotalBillable, pProductivityTasks.Scheduled, pProductivityTasks.Progress, pProductivityTasks.IsOutOfScope).Where("id = ?", pProductivityTasks.ID)
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
*	Name : DeleteProductivityTasks
*	Params: pProductivityTasksId
*	Return: int, error
*	Description: Delete ProductivityTasks in DB
 */
func DeleteProductivityTasks(pID int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete productivityTasks in DB
	q := session.DeleteFrom("ProductivityTasks").Where("id", pID)
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}

/**
*	Name : GetProductivityTasksByFilters
*	Params: pName
*	Return: []*DOMAIN.ProductivityTasks
*	Description: Get a slice of productivityTasks from productivityTasks table
 */
func GetProductivityTasksByFilters(pProductivityTasksFilters *DOMAIN.ProductivityTasks) ([]*DOMAIN.ProductivityTasks, string) {
	// Slice to keep all productivityTasks
	productivityTasks := []*DOMAIN.ProductivityTasks{}
	// Filter productivityTasks
	result := getProductivityTasksCollection().Find()

	// Close session when ends the method
	defer session.Close()

	var filters bytes.Buffer
	if pProductivityTasksFilters.ID != 0 {
		filters.WriteString("id = '")
		filters.WriteString(strconv.Itoa(pProductivityTasksFilters.ID))
		filters.WriteString("'")
	}
	if pProductivityTasksFilters.ProjectID != 0 {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("project_id = '")
		filters.WriteString(strconv.Itoa(pProductivityTasksFilters.ProjectID))
		filters.WriteString("'")
	}
	if pProductivityTasksFilters.Name != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("name = '")
		filters.WriteString(pProductivityTasksFilters.Name)
		filters.WriteString("'")
	}

	if filters.String() != "" {
		// Add all productivityTasks in productivityTasks variable
		err := result.Where(filters.String()).All(&productivityTasks)
		if err != nil {
			log.Error(err)
		}
	}
	return productivityTasks, filters.String()
}
