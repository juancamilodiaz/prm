package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getTrainingCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getTrainingCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("Training")
}

/**
*	Name : GetAllTraining
*	Return: []*DOMAIN.Training
*	Description: Get all resources and skills in a Training table
 */
func GetAllTraining() []*DOMAIN.Training {
	// Slice to keep all Training
	var Training []*DOMAIN.Training
	// Add all Training in resources variable
	err := getTrainingCollection().Find().All(&Training)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return Training
}

/**
*	Name : getTrainingById
*	Params: pId
*	Return: *DOMAIN.Training
*	Description: Get a Training by ID in a Training table
 */
func GetTrainingById(pId int) *DOMAIN.Training {
	// Training structure
	training := DOMAIN.Training{}
	// Add in Training variable, the Training where ID is the same that the param
	res := getTrainingCollection().Find(db.Cond{"id": pId})
	log.Debug("find Training by ID:", pId)
	// Close session when ends the method
	defer session.Close()
	err := res.One(&training)
	if err != nil {
		log.Error(err)
	}
	log.Debug("Result:", training)
	return &training
}

/**
*	Name : AddTraining
*	Params: pTraining
*	Return: int, error
*	Description: Add skill in DB
 */
func AddTraining(pTraining *DOMAIN.Training) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert skill in DB
	res, err := session.InsertInto("Training").Columns(
		"resource_id", "type_id").Values(
		pTraining.ResourceId, pTraining.TypeId).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return int(insertId), nil
}

/**
*	Name : UpdateTraining
*	Params: pTraining
*	Return: int, error
*	Description: Update skill in DB
 */
func UpdateTraining(pTraining *DOMAIN.Training) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update skill in DB
	q := session.Update("Training").Set("resource_id = ?, type_id =?", pTraining.ResourceId, pTraining.TypeId).Where("id = ?", int(pTraining.ID))
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
*	Name : DeleteTraining
*	Params: pTrainingId
*	Return: int, error
*	Description: Delete skill in DB
 */
func DeleteTraining(pTrainingId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete skill in DB
	q := session.DeleteFrom("Training").Where("id", int(pTrainingId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}
