package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getTypeSkillsCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getTypeSkillsCollection() db.Collection {
	// Get a session
	session = GetSession()
	if session != nil {
		// Return table resource in the session
		return session.Collection("TypeSkills")
	} else {
		return nil
	}
}

/**
*	Name : GetAllTypesSkills
*	Return: []*DOMAIN.TypeSkills
*	Description: Get all Type Skills in a TypeSkills table
 */
func GetAllTypesSkills() []*DOMAIN.TypeSkills {
	// Slice to keep all typesSkills
	var typesSkills []*DOMAIN.TypeSkills
	if getTypeSkillsCollection() != nil {
		// Add all types Skills in typesSkills variable
		err := getTypeSkillsCollection().Find().All(&typesSkills)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Error(err)
		}
	}

	return typesSkills
}

/**
*	Name : GetTypeSkillsById
*	Params: pId
*	Return: *DOMAIN.Types
*	Description: Get a Skill by Id in a TypeSkills table
 */
func GetTypeSkillsById(pId int) *DOMAIN.TypeSkills {
	// Types structure
	typeSkills := DOMAIN.TypeSkills{}
	if getTypeSkillsCollection() != nil {
		// get Types variable, the Types where ID is the same that the param
		res := getTypeSkillsCollection().Find(db.Cond{"id": pId})
		// Close session when ends the method
		count, err := res.Count()
		if count > 0 {
			err = res.One(&typeSkills)
			if err != nil {
				log.Debug(err)
			}
			return &typeSkills
		}
	}
	return nil
}

/**
*	Name : GetTypesSkillsByTypeId
*	Params: pId
*	Return: *DOMAIN.Types
*	Description: Get a Skills by TypeId in a TypeSkills table
 */
func GetTypesSkillsByTypeId(pTypeId int) []*DOMAIN.TypeSkills {
	// Types structure
	var typeSkills []*DOMAIN.TypeSkills
	if getTypeSkillsCollection() != nil {
		// Add in Types variable, the Types where ID is the same that the param
		err := getTypeSkillsCollection().Find(db.Cond{"type_id": pTypeId}).All(&typeSkills)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Debug(err)
		}
	}
	return typeSkills
}

/**
*	Name : GetTypesSkillsBySkillId
*	Params: pId
*	Return: *DOMAIN.Types
*	Description: Get a Skills by SkillId in a TypeSkills table
 */
func GetTypesSkillsBySkillId(pSkillId int) []*DOMAIN.TypeSkills {
	// Types structure
	var typeSkills []*DOMAIN.TypeSkills
	if getTypeSkillsCollection() != nil {
		// Add in Types variable, the Types where ID is the same that the param
		err := getTypeSkillsCollection().Find(db.Cond{"skill_id": pSkillId}).All(&typeSkills)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Debug(err)
		}
	}
	return typeSkills
}

/**
*	Name : GetTypesSkillsByTypeId
*	Params: pId
*	Return: *DOMAIN.Types
*	Description: Get a Skills by TypeId in a TypeSkills table
 */
func GetTypesSkillsByTypeIdAndSkillId(pTypeId, pSkillId int) *DOMAIN.TypeSkills {
	// Types structure
	typeSkills := DOMAIN.TypeSkills{}
	if getTypeSkillsCollection() != nil {
		// Add in Types variable, the Types where ID is the same that the param
		res := getTypeSkillsCollection().Find(db.Cond{"type_id": pTypeId}).And(db.Cond{"skill_id": pSkillId})
		// Close session when ends the method
		defer session.Close()

		count, err := res.Count()
		if count > 0 {
			err = res.One(&typeSkills)
			if err != nil {
				log.Debug(err)
			}
			return &typeSkills
		}
	}
	return nil
}

/**
*	Name : DeleteTypeSkillsByTypeIdAndSkillId
*	Params: pTypeId, pSkillId
*	Return: (int, error)
*	Description: Delete a Skills by TypeId and pSkillIdin a TypeSkills table
 */
func DeleteTypeSkillsByTypeIdAndSkillId(pTypeId, pSkillId int) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Delete TypeSkills in DB
		q := session.DeleteFrom("TypeSkills").Where("type_id", int(pTypeId)).And("skill_id", int(pSkillId))
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
*	Name : DeleteTypeSkillsById
*	Params: pId
*	Return: (int, error)
*	Description: Delete a Skills by TypeId and pSkillIdin a TypeSkills table
 */
func DeleteTypeSkillsById(pTypeSkillId int) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Delete TypeSkills in DB
		q := session.DeleteFrom("TypeSkills").Where("id", pTypeSkillId)
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
*	Name : DeleteTypeSkillsById
*	Params: pId
*	Return: (int, error)
*	Description: Delete a Skills by TypeId and pSkillIdin a TypeSkills table
 */
func AddSkillToType(pTypeSkillId DOMAIN.TypeSkills) (int, error) {
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Insert in DB
		res, err := session.InsertInto("TypeSkills").Columns(
			"type_id",
			"skill_id",
			"skill_name",
			"value").Values(pTypeSkillId.TypeId, pTypeSkillId.SkillId, pTypeSkillId.Name, pTypeSkillId.Value).Exec()
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
*	Name : UpdateTypeSkills
*	Params: pTypeSkills
*	Return: int, error
*	Description: Update TypeSkills in DB
 */
func UpdateTypeSkills(pTypeSkills *DOMAIN.TypeSkills) (int64, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Update TypeSkills in DB
		q := session.Update("TypeSkills").Set("skill_name = ?, value = ?", pTypeSkills.Name, pTypeSkills.Value).Where("id = ?", int(pTypeSkills.ID))
		res, err := q.Exec()
		if err != nil {
			log.Error(err)
			return 0, err
		}
		// Get rows updated
		updateCount, err := res.RowsAffected()
		return updateCount, nil
	} else {
		return 0, nil
	}
}
