package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getTypesCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getTypesCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("Type")
}

/**
*	Name : GetAllTypes
*	Return: []*DOMAIN.Types
*	Description: Get all resources and skills in a Types table
 */
func GetAllTypes() []*DOMAIN.Type {
	// Slice to keep all Types
	var Types []*DOMAIN.Type
	// Add all Types in resources variable
	err := getTypesCollection().Find().All(&Types)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return Types
}

/**
*	Name : GetTypesById
*	Params: pId
*	Return: *DOMAIN.Types
*	Description: Get a Types by ID in a Types table
 */
func GetTypesById(pId int) *DOMAIN.Type {
	// Types structure
	Types := DOMAIN.Type{}
	// Add in Types variable, the Types where ID is the same that the param
	res := getTypesCollection().Find(db.Cond{"id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&Types)
	if err != nil {
		log.Error(err)
	}
	return &Types
}

/**
*	Name : AddType
*	Params: pType
*	Return: int, error
*	Description: Add skill in DB
 */
func AddType(pType *DOMAIN.Type) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert skill in DB
	res, err := session.InsertInto("Type").Columns(
		"name", "apply_to").Values(
		pType.Name, pType.ApplyTo).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return int(insertId), nil
}

/**
*	Name : UpdateType
*	Params: pType
*	Return: int, error
*	Description: Update skill in DB
 */
func UpdateType(pType *DOMAIN.Type) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update skill in DB
	q := session.Update("Type").Set("name = ?, apply_to = ?", pType.Name, pType.ApplyTo).Where("id = ?", int(pType.ID))
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
*	Name : DeleteType
*	Params: pTypeId
*	Return: int, error
*	Description: Delete skill in DB
 */
func DeleteType(pTypeId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete skill in DB
	q := session.DeleteFrom("Type").Where("id", int(pTypeId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}
