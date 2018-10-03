package dao

import (
	"bytes"
	"strconv"

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
	if session != nil {
		// Return table resource in the session
		return session.Collection("Training")
	} else {
		return nil
	}
}

/**
*	Name : GetAllTraining
*	Return: []*DOMAIN.Training
*	Description: Get all resources and skills in a Training table
 */
func GetAllTraining() []*DOMAIN.Training {
	// Slice to keep all Training
	var Training []*DOMAIN.Training
	if getTrainingCollection() != nil {
		// Add all Training in resources variable
		err := getTrainingCollection().Find().All(&Training)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Error(err)
		}
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
	if getTrainingCollection() != nil {
		// Add in Training variable, the Training where ID is the same that the param
		res := getTrainingCollection().Find(db.Cond{"id": pId})
		log.Debug("find Training by ID:", pId)
		// Close session when ends the method
		defer session.Close()
		err := res.One(&training)
		if err != nil {
			log.Error(err)
			return nil
		}
		log.Debug("Result:", training)
	}
	return &training
}

/**
*	Name : GetTrainingByTypeId
*	Params: pId
*	Return: *DOMAIN.Training
*	Description: Get a Training by Type ID in a Training table
 */
func GetTrainingByTypeId(pTypeId int) []*DOMAIN.Training {
	// Training structure
	trainings := []*DOMAIN.Training{}
	if getTrainingCollection() != nil {
		// Add in Training variable, the Training where ID is the same that the param
		res := getTrainingCollection().Find().Where("type_id = ?", pTypeId)
		// Close session when ends the method
		defer session.Close()
		err := res.All(&trainings)
		if err != nil {
			log.Error(err)
			return nil
		}
	}
	return trainings
}

/**
*	Name : GetTrainingBySkillId
*	Params: pId
*	Return: *DOMAIN.Training
*	Description: Get a Training by Skill ID in a Training table
 */
func GetTrainingBySkillId(pSkillId int) []*DOMAIN.Training {
	// Training structure
	trainings := []*DOMAIN.Training{}
	if getTrainingCollection() != nil {
		// Add in Training variable, the Training where ID is the same that the param
		res := getTrainingCollection().Find().Where("skill_id = ?", pSkillId)
		// Close session when ends the method
		defer session.Close()
		err := res.All(&trainings)
		if err != nil {
			log.Error(err)
			return nil
		}
	}
	return trainings
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
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Insert skill in DB
		res, err := session.InsertInto("Training").Columns(
			"type_id", "skill_id", "name").Values(
			pTraining.TypeId, pTraining.SkillId, pTraining.Name).Exec()
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
*	Name : UpdateTraining
*	Params: pTraining
*	Return: int, error
*	Description: Update training in DB
 */
func UpdateTraining(pTraining *DOMAIN.Training) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Update skill in DB
		q := session.Update("Training").Set("name =?", pTraining.Name).Where("id = ?", int(pTraining.ID))
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
*	Name : DeleteTraining
*	Params: pTrainingId
*	Return: int, error
*	Description: Delete skill in DB
 */
func DeleteTraining(pTrainingId int) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
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
	} else {
		return 0, nil
	}
}

/**
*	Name : GetTrainingsByFilters
*	Params: pName
*	Return: []*DOMAIN.Training
*	Description: Get a slice of training from training table
 */
func GetTrainingsByFilters(pTrainingFilters *DOMAIN.Training) ([]*DOMAIN.Training, string) {
	// Slice to keep all trainings
	trainings := []*DOMAIN.Training{}
	var string_response string
	if getTrainingCollection() != nil {
		// Filter trainings
		result := getTrainingCollection().Find()

		// Close session when ends the method
		defer session.Close()

		var filters bytes.Buffer
		if pTrainingFilters.ID != 0 {
			filters.WriteString("id = '")
			filters.WriteString(strconv.Itoa(pTrainingFilters.ID))
			filters.WriteString("'")
		}
		if pTrainingFilters.Name != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("name = '")
			filters.WriteString(pTrainingFilters.Name)
			filters.WriteString("'")
		}
		if pTrainingFilters.TypeId != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("type_id = '")
			filters.WriteString(strconv.Itoa(pTrainingFilters.TypeId))
			filters.WriteString("'")
		}
		if pTrainingFilters.SkillId != 0 {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("skill_id = '")
			filters.WriteString(strconv.Itoa(pTrainingFilters.SkillId))
			filters.WriteString("'")
		}

		if filters.String() != "" {
			// Add all training in trainings variable
			err := result.Where(filters.String()).All(&trainings)
			if err != nil {
				log.Error(err)
			}
		}
		string_response = filters.String()
	}
	return trainings, string_response
}
