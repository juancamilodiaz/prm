package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getResourceSkillsCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getResourceSkillsCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("ResourceSkills")
}

/**
*	Name : GetAllResourceSkills
*	Return: []*DOMAIN.ResourceSkills
*	Description: Get all resources and skills in a ResourceSkills table
 */
func GetAllResourceSkills() []*DOMAIN.ResourceSkills {
	// Slice to keep all ResourceSkills
	var resourceSkills []*DOMAIN.ResourceSkills
	// Add all ResourceSkills in resources variable
	err := getResourceSkillsCollection().Find().All(resourceSkills)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return resourceSkills
}

/**
*	Name : GetResourceSkillById
*	Params: pId
*	Return: *DOMAIN.ResourceSkills
*	Description: Get a resourceSkill by ID in a ResourceSkills table
 */
func GetResourceSkillsById(pId int) *DOMAIN.ResourceSkills {
	// ResourceSkills structure
	resourceSkills := DOMAIN.ResourceSkills{}
	// Add in resourceSkills variable, the resourceSkills where ID is the same that the param
	res := getResourceSkillsCollection().Find(db.Cond{"resource_id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&resourceSkills)
	if err != nil {
		log.Error(err)
	}
	return &resourceSkills
}

/**
*	Name : GetResourceSkillsByResourceId
*	Params: pId
*	Return: *DOMAIN.ResourceSkills
*	Description: Get a resourceSkill by ResourceId in a ResourceSkills table
 */
func GetResourceSkillsByResourceId(pId int) []*DOMAIN.ResourceSkills {
	// Slice to keep all ResourceSkills
	var resourceSkills []*DOMAIN.ResourceSkills
	// Add all ResourceSkills in resourceSkills variable
	err := getResourceSkillsCollection().Find(db.Cond{"resource_id": pId}).All(&resourceSkills)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return resourceSkills
}

/**
*	Name : GetResourceSkillsBySkillId
*	Params: pId
*	Return: *DOMAIN.ResourceSkills
*	Description: Get a resourceSkill by SkillId in a ResourceSkills table
 */
func GetResourceSkillsBySkillId(pId int) []*DOMAIN.ResourceSkills {
	// Slice to keep all ResourceSkills
	var resourceSkills []*DOMAIN.ResourceSkills
	// Add all ResourceSkills in resourceSkills variable
	err := getResourceSkillsCollection().Find(db.Cond{"skill_id": pId}).All(&resourceSkills)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Debug(err)
	}
	return resourceSkills
}

/**
*	Name : GetResourceSkillsByResourceIdAndSkillId
*	Params: pResourceId, pSkillId
*	Return: *DOMAIN.ResourceSkills
*	Description: Get a resourceSkill by ResourceId and SkillId in a ResourceSkills table
 */
func GetResourceSkillsByResourceIdAndSkillId(pResourceId, pSkillId int) *DOMAIN.ResourceSkills {
	// ResourceSkills structure
	resourceSkills := DOMAIN.ResourceSkills{}
	// Add in resourceSkills variable, the resourceSkills where ID is the same that the param
	res := getResourceSkillsCollection().Find(db.Cond{"resource_id": pResourceId}).And(db.Cond{"skill_id": pSkillId})
	// Close session when ends the method
	defer session.Close()
	count, err := res.Count()
	if count > 0 {
		err = res.One(&resourceSkills)
		if err != nil {
			log.Debug(err)
		}
		return &resourceSkills
	}

	return nil
}

/**
*	Name : AddResourceSkills
*	Params: pResourceSkills
*	Return: int, error
*	Description: Add ResourceSkills in DB
 */
func AddResourceSkills(pResourceSkills *DOMAIN.ResourceSkills) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert in DB
	res, err := session.InsertInto("ResourceSkills").Columns(
		"resource_id",
		"skill_id",
		"name",
		"value").Values(
		pResourceSkills.ResourceId,
		pResourceSkills.SkillId,
		pResourceSkills.Name,
		pResourceSkills.Value).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return int(insertId), nil
}

/**
*	Name : UpdateResourceSkills
*	Params: pResourceSkills
*	Return: int, error
*	Description: Update ResourceSkills in DB
 */
func UpdateResourceSkills(pResourceSkills *DOMAIN.ResourceSkills) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update ResourceSkills in DB
	q := session.Update("ResourceSkills").Set("name = ?, value = ?", pResourceSkills.Name, pResourceSkills.Value).Where("id = ?", pResourceSkills.ID)
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
*	Name : DeleteResourceSkills
*	Params: pResourceSkillsId
*	Return: int, error
*	Description: Delete ResourceSkills in DB
 */
func DeleteResourceSkills(pResourceSkillsId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete ResourceSkills in DB
	q := session.DeleteFrom("ResourceSkills").Where("id", pResourceSkillsId)
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
*	Name : DeleteResourceSkillsByResourceIdAndSkillId
*	Params: pResourceId, pSkillId
*	Return: int, error
*	Description: Delete ResourceSkills by ResourceId and SkillId in DB
 */
func DeleteResourceSkillsByResourceIdAndSkillId(pResourceId, pSkillId int) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete ResourceSkills in DB
	q := session.DeleteFrom("ResourceSkills").Where("resource_id", int(pResourceId)).And("skill_id", int(pSkillId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return int(deleteCount), nil
}
