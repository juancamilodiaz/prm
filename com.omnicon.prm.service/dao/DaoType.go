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
*	Name : GetResourceSkillById
*	Params: pId
*	Return: *DOMAIN.Types
*	Description: Get a resourceSkill by ID in a Types table
 */
func GetTypesById(pId int64) *DOMAIN.Type {
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
