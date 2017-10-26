package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
	"upper.io/db.v3/lib/sqlbuilder"
)

/**
*	Name : getTrainingResourcesCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getTrainingResourcesCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("TrainingResources")
}

/**
*	Name : GetAllTrainingResources
*	Return: []*DOMAIN.TrainingResources
*	Description: Get all trainingResources in a TrainingResources table
 */
func GetAllTrainingResources() []*DOMAIN.TrainingResources {
	// Slice to keep all TrainingResources
	var trainingResources []*DOMAIN.TrainingResources
	// Add all TrainingResources in resources variable
	err := getTrainingResourcesCollection().Find().All(&trainingResources)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return trainingResources
}

/**
*	Name : getTrainingResourcesById
*	Params: pId
*	Return: *DOMAIN.TrainingResources
*	Description: Get a TrainingResources by ID in a TrainingResources table
 */
func getTrainingResourcesById(pId int) *DOMAIN.TrainingResources {
	// TrainingResources structure
	TrainingResources := DOMAIN.TrainingResources{}
	// Add in TrainingResources variable, the TrainingResources where ID is the same that the param
	res := getTrainingResourcesCollection().Find(db.Cond{"id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&TrainingResources)
	if err != nil {
		log.Error(err)
	}
	return &TrainingResources
}

/**
*	Name : GetTrainingResourcesByTrainingId
*	Params: pId
*	Return: *DOMAIN.TrainingResources
*	Description: Get a TrainingResources by ID in a TrainingResources table
 */
func GetTrainingResourcesByTrainingId(pTrainingId int) []*DOMAIN.TrainingResources {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	q := session.Select("trn.id", "trn.training_id", "trn.resource_id", "skill.name skill_name",
		"trn.start_date", "trn.end_date", "trn.duration", "trn.progress",
		"trn.test_result", "trn.result_status").
		From("TrainingResources AS trn").
		Join("Skill AS skill").
		On("skill.id = trn.resource_id").
		And("training_id", pTrainingId)

	rows, err := q.Query()
	if err != nil {
		log.Error(err)
		return nil
	}

	trainingResources := []*DOMAIN.TrainingResources{}
	iter := sqlbuilder.NewIterator(rows)
	err = iter.All(&trainingResources)

	return trainingResources
}

/**
*	Name : AddTrainingResources
*	Params: pTrainingResources
*	Return: int, error
*	Description: Add trainingResources in DB
 */
func AddTrainingResources(pTrainingResources *DOMAIN.TrainingResources) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert trainingResources in DB
	res, err := session.InsertInto("TrainingResources").Columns(
		"training_id", "resource_id", "start_date", "end_date", "duration", "progress", "test_result", "result_status").Values(
		pTrainingResources.TrainingId, pTrainingResources.ResourceId, pTrainingResources.StartDate, pTrainingResources.EndDate,
		pTrainingResources.Duration, pTrainingResources.Progress, pTrainingResources.TestResult, pTrainingResources.ResultStatus).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return int(insertId), nil
}

/**
*	Name : AddBulkTrainingResources
*	Params: pTrainingResources
*	Return: int, error
*	Description: Add trainingResources in DB
 */
func AddBulkTrainingResources(pTrainingResources []*DOMAIN.TrainingResources) error {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert trainingResources in DB
	batch := session.InsertInto("TrainingResources").Columns(
		"training_id", "resource_id", "start_date", "end_date",
		"duration", "progress", "test_result", "result_status").Batch(len(pTrainingResources))

	go func() {
		defer batch.Done()
		for _, trSkill := range pTrainingResources {
			batch.Values(
				trSkill.TrainingId, trSkill.ResourceId, trSkill.StartDate, trSkill.EndDate,
				trSkill.Duration, trSkill.Progress, trSkill.TestResult, trSkill.ResultStatus)
		}
	}()
	err := batch.Wait()
	if err != nil {
		log.Error(err)
		return err
	}
	return nil

}

/**
*	Name : UpdateTrainingResources
*	Params: pTrainingResources
*	Return: int, error
*	Description: Update trainingResources in DB
 */
func UpdateTrainingResources(pTrainingResources *DOMAIN.TrainingResources) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update trainingResources in DB
	q := session.Update("TrainingResources").Set("training_id = ?, resource_id =?, start_date=?, end_date=?, duration=?, progress=?, test_result=?, result_status=?",
		pTrainingResources.TrainingId, pTrainingResources.ResourceId, pTrainingResources.StartDate, pTrainingResources.EndDate,
		pTrainingResources.Duration, pTrainingResources.Progress, pTrainingResources.TestResult, pTrainingResources.ResultStatus).Where("id = ?", pTrainingResources.ID)
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
*	Name : DeleteTrainingResources
*	Params: pTrainingResourcesId
*	Return: int, error
*	Description: Delete trainingResources in DB
 */
func DeleteTrainingResources(pTrainingResourcesId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete trainingResources in DB
	q := session.DeleteFrom("TrainingResources").Where("id", int(pTrainingResourcesId))
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
*	Name : DeleteTrainingResourcesByTrainingId
*	Params: pTrainingId
*	Return: int, error
*	Description: Delete TrainingResources by TrainingId in DB
 */
func DeleteTrainingResourcesByTrainingId(pTrainingId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete TrainingResources in DB
	q := session.DeleteFrom("TrainingResources").Where("training_id", int(pTrainingId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}