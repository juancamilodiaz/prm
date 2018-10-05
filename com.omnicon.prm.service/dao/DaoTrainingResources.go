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
	if session != nil {
		// Return table resource in the session
		return session.Collection("TrainingResources")
	} else {
		return nil
	}

}

/**
*	Name : GetAllTrainingResources
*	Return: []*DOMAIN.TrainingResources
*	Description: Get all trainingResources in a TrainingResources table
 */
func GetAllTrainingResources() []*DOMAIN.TrainingResources {
	// Slice to keep all TrainingResources
	var trainingResources []*DOMAIN.TrainingResources
	if getTrainingResourcesCollection() != nil {
		// Add all TrainingResources in resources variable
		err := getTrainingResourcesCollection().Find().All(&trainingResources)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Error(err)
		}
	}

	return trainingResources
}

/**
*	Name : getTrainingResourcesById
*	Params: pId
*	Return: *DOMAIN.TrainingResources
*	Description: Get a TrainingResources by ID in a TrainingResources table
 */
func GetTrainingResourcesById(pId int) *DOMAIN.TrainingResources {
	// TrainingResources structure
	TrainingResources := DOMAIN.TrainingResources{}
	if getTrainingResourcesCollection() != nil {
		// Add in TrainingResources variable, the TrainingResources where ID is the same that the param
		res := getTrainingResourcesCollection().Find(db.Cond{"id": pId})
		// Close session when ends the method
		defer session.Close()
		err := res.One(&TrainingResources)
		if err != nil {
			log.Error(err)
		}
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
	trainingResources := []*DOMAIN.TrainingResources{}
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Insert in DB
		q := session.Select("trn.id", "trn.training_id", "trn.resource_id", "resource.name resource_name",
			"trn.start_date", "trn.end_date", "trn.duration", "trn.progress",
			"trn.test_result", "trn.result_status").
			From("TrainingResources AS trn").
			Join("Resource AS resource").
			On("resource.id = trn.resource_id").
			And("training_id", pTrainingId)

		rows, err := q.Query()
		if err != nil {
			log.Error(err)
			return nil
		}

		iter := sqlbuilder.NewIterator(rows)
		err = iter.All(&trainingResources)

	}
	return trainingResources

}

/**
*	Name : GetTrainingResourcesByResourceId
*	Params: pResourceId
*	Return: *DOMAIN.TrainingResources
*	Description: Get a trainingResource by ResourceId in a TrainingResources table
 */
func GetTrainingResourcesByResourceId(pResourceId int) []*DOMAIN.TrainingResources {
	// TrainingResources structure
	trainingResources := []*DOMAIN.TrainingResources{}
	if getTrainingResourcesCollection() != nil {
		// Add in trainingResources variable, the trainingResources where ID is the same that the param
		res := getTrainingResourcesCollection().Find().Where("resource_id  = ?", pResourceId)
		// Close session when ends the method
		defer session.Close()
		// Add all trainingResources in trainingResources variable
		err := res.All(&trainingResources)
		if err != nil {
			log.Error(err)
		}
	}
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
	if session != nil {
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
	} else {
		return 0, nil
	}
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
	if session != nil {
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
	if session != nil {
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
	} else {
		return 0, nil
	}
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
	if session != nil {
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
	} else {
		return 0, nil
	}
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
	if session != nil {
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
	} else {
		return 0, nil
	}
}

/**
*	Name : GetTrainingResourcesByResourceIdAndTrainingId
*	Params: pResourceId, pTrainingId
*	Return: *DOMAIN.TrainingResources
*	Description: Get a trainingResource by ResourceId and TrainingId in a TrainingResources table
 */
func GetTrainingResourcesByResourceIdAndTrainingId(pResourceId, pTrainingId int) *DOMAIN.TrainingResources {
	// TrainingResources structure
	trainingResources := DOMAIN.TrainingResources{}
	if getTrainingResourcesCollection() != nil {
		// Add in trainingResources variable, the trainingResources where ID is the same that the param
		res := getTrainingResourcesCollection().Find(db.Cond{"resource_id": pResourceId}).And(db.Cond{"training_id": pTrainingId})
		// Close session when ends the method
		defer session.Close()
		count, err := res.Count()
		if count > 0 {
			err = res.One(&trainingResources)
			if err != nil {
				log.Debug(err)
			}
			return &trainingResources
		}
	}

	return nil
}
