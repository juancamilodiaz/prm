package dao

import (
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getSkillCollection
*	Return: db.Collection
*	Description: Get table Skill in a session
 */
func getSkillCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table skill in the session
	return session.Collection("Skill")
}

/**
*	Name : GetAllSkills
*	Return: []*DOMAIN.Skill
*	Description: Get all skills in a skill table
 */
func GetAllSkills() []*DOMAIN.Skill {
	// Slice to keep all skills
	var skills []*DOMAIN.Skill
	// Add all skills in skills variable
	err := getSkillCollection().Find().All(skills)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return skills
}

/**
*	Name : GetSkillById
*	Params: pId
*	Return: *DOMAIN.Skill
*	Description: Get a skill by ID in a skill table
 */
func GetSkillById(pId int64) *DOMAIN.Skill {
	// Skill structure
	skill := DOMAIN.Skill{}
	// Add in skill variable, the skill where ID is the same that the param
	res := getSkillCollection().Find(db.Cond{"id": pId})
	// Close session when ends the method
	defer session.Close()
	err := res.One(&skill)
	if err != nil {
		log.Error(err)
	}
	return &skill
}

/**
*	Name : GetSkillsByName
*	Params: pName
*	Return: []*DOMAIN.Skill
*	Description: Get a slice of skill with a name in a skill table
 */
func GetSkillsByName(pName string) []*DOMAIN.Skill {
	// Slice to keep all skills
	skills := []*DOMAIN.Skill{}
	// Filter skills by name
	res := getSkillCollection().Find().Where("name  = ?", pName)
	// Close session when ends the method
	defer session.Close()
	// Add all skills in skills variable
	err := res.All(&skills)
	if err != nil {
		log.Error(err)
	}
	return skills
}

/**
*	Name : AddSkill
*	Params: pSkill
*	Return: int, error
*	Description: Add skill in DB
 */
func AddSkill(pSkill *DOMAIN.Skill) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Insert skill in DB
	res, err := session.InsertInto("Skill").Columns(
		"name").Values(
		pSkill.Name).Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows inserted
	insertId, err := res.LastInsertId()
	return insertId, nil
}

/**
*	Name : UpdateSkill
*	Params: pSkill
*	Return: int, error
*	Description: Update skill in DB
 */
func UpdateSkill(pSkill *DOMAIN.Skill) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update skill in DB
	q := session.Update("Skill").Set("name = ?", pSkill.Name).Where("id = ?", int(pSkill.ID))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows updated
	updateCount, err := res.RowsAffected()
	return updateCount, nil
}

/**
*	Name : DeleteSkill
*	Params: pSkillId
*	Return: int, error
*	Description: Delete skill in DB
 */
func DeleteSkill(pSkillId int64) (int64, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Delete skill in DB
	q := session.DeleteFrom("Skill").Where("id", int(pSkillId))
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows deleted
	deleteCount, err := res.RowsAffected()
	return deleteCount, nil
}
