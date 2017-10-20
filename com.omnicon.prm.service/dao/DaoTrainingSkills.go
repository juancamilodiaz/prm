package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
	"upper.io/db.v3/lib/sqlbuilder"
)

/**
*	Name : getTrainingSkillsCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getTrainingSkillsCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("TrainingSkills")
}

/**
*	Name : GetAllTrainingSkills
*	Return: []*DOMAIN.TrainingSkills
*	Description: Get all resources and skills in a TrainingSkills table
 */
func GetAllTrainingSkills() []*DOMAIN.TrainingSkills {
	// Slice to keep all TrainingSkills
	var trainingSkills []*DOMAIN.TrainingSkills
	// Add all TrainingSkills in resources variable
	err := getTrainingSkillsCollection().Find().All(&trainingSkills)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return trainingSkills
}

/**
*	Name : getTrainingSkillsById
*	Params: pId
*	Return: *DOMAIN.TrainingSkills
*	Description: Get a TrainingSkills by ID in a TrainingSkills table
 */
func getTrainingSkillsById(pId int) *DOMAIN.TrainingSkills {
	// TrainingSkills structure
	TrainingSkills := DOMAIN.TrainingSkills{}
	// Add in TrainingSkills variable, the TrainingSkills where ID is the same that the param
	res := getTrainingSkillsCollection().Find(db.Cond{"id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&TrainingSkills)
	if err != nil {
		log.Error(err)
	}
	return &TrainingSkills
}

/**
*	Name : GetTrainingSkillsByTrainingId
*	Params: pId
*	Return: *DOMAIN.TrainingSkills
*	Description: Get a TrainingSkills by ID in a TrainingSkills table
 */
func GetTrainingSkillsByTrainingId(pTrainingId int) []*DOMAIN.TrainingSkills {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	q := session.Select("trn.id", "trn.training_id", "trn.skill_id", "skill.name skill_name",
		"trn.start_date", "trn.end_date", "trn.duration", "trn.progress",
		"trn.test_result", "trn.result_status").
		From("TrainingSkills AS trn").
		Join("Skill AS skill").
		On("skill.id = trn.skill_id").
		And("training_id", pTrainingId)

	rows, err := q.Query()
	if err != nil {
		log.Error(err)
		return nil
	}

	trainingSkills := []*DOMAIN.TrainingSkills{}
	iter := sqlbuilder.NewIterator(rows)
	err = iter.All(&trainingSkills)

	return trainingSkills
}

/**
*	Name : AddTrainingSkills
*	Params: pTrainingSkills
*	Return: int, error
*	Description: Add skill in DB
 */
func AddTrainingSkills(pTrainingSkills *DOMAIN.TrainingSkills) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert skill in DB
	res, err := session.InsertInto("TrainingSkills").Columns(
		"training_id", "skill_id", "start_date", "end_date", "duration", "progress", "test_result", "result_status").Values(
		pTrainingSkills.TrainingId, pTrainingSkills.SkillId, pTrainingSkills.StartDate, pTrainingSkills.EndDate,
		pTrainingSkills.Duration, pTrainingSkills.Progress, pTrainingSkills.TestResult, pTrainingSkills.ResultStatus).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return int(insertId), nil
}

/**
*	Name : AddBulkTrainingSkills
*	Params: pTrainingSkills
*	Return: int, error
*	Description: Add skill in DB
 */
func AddBulkTrainingSkills(pTrainingSkills []*DOMAIN.TrainingSkills) error {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert skill in DB
	batch := session.InsertInto("TrainingSkills").Columns(
		"training_id", "skill_id", "start_date", "end_date",
		"duration", "progress", "test_result", "result_status").Batch(len(pTrainingSkills))

	go func() {
		defer batch.Done()
		for _, trSkill := range pTrainingSkills {
			batch.Values(
				trSkill.TrainingId, trSkill.SkillId, trSkill.StartDate, trSkill.EndDate,
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
*	Name : UpdateTrainingSkills
*	Params: pTrainingSkills
*	Return: int, error
*	Description: Update skill in DB
 */
func UpdateTrainingSkills(pTrainingSkills *DOMAIN.TrainingSkills) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update skill in DB
	q := session.Update("TrainingSkills").Set("training_id = ?, skill_id =?, start_date=?, end_date=?, duration=?, progress=?, test_result=?, result_status=?",
		pTrainingSkills.TrainingId, pTrainingSkills.SkillId, pTrainingSkills.StartDate, pTrainingSkills.EndDate,
		pTrainingSkills.Duration, pTrainingSkills.Progress, pTrainingSkills.TestResult, pTrainingSkills.ResultStatus).Where("id = ?", pTrainingSkills.ID)
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
*	Name : DeleteTrainingSkills
*	Params: pTrainingSkillsId
*	Return: int, error
*	Description: Delete skill in DB
 */
func DeleteTrainingSkills(pTrainingSkillsId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete skill in DB
	q := session.DeleteFrom("TrainingSkills").Where("id", int(pTrainingSkillsId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}
