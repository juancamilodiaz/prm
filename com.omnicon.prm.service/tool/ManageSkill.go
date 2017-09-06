package tool

import (
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

/**
* Function to create a new skill from CreateSkillRQ
 */
func CreateSkill(pRequest *DOMAIN.CreateSkillRQ) *DOMAIN.CreateSkillRS {
	timeResponse := time.Now()
	skill := util.MappingCreateSkill(pRequest)
	id, err := dao.AddSkill(skill)
	// Create response
	response := DOMAIN.CreateSkillRS{}
	if err != nil {
		message := "Skill wasn't insert"
		log.Error(message)
		response.Message = message
		response.Skill = nil
		response.Status = "Error"
		return &response
	}
	// Get Skill inserted
	skill = dao.GetSkillById(id)
	response.Skill = skill
	response.Status = "OK"

	header := new(DOMAIN.CreateSkillRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

/**
* Function to update a skill from UpdateSkillRQ
 */
func UpdateSkill(pRequest *DOMAIN.UpdateSkillRQ) *DOMAIN.UpdateSkillRS {
	timeResponse := time.Now()
	response := DOMAIN.UpdateSkillRS{}
	oldSkill := dao.GetSkillById(pRequest.ID)
	if oldSkill != nil {
		if pRequest.Name != "" {
			oldSkill.Name = pRequest.Name
		}
		// Save in DB
		rowsUpdated, err := dao.UpdateSkill(oldSkill)
		if err != nil || rowsUpdated <= 0 {
			message := "Skill wasn't update"
			log.Error(message)
			response.Message = message
			response.Skill = nil
			response.Status = "Error"
			return &response
		}
		// Get Skill updated
		skill := dao.GetSkillById(pRequest.ID)
		response.Skill = skill
		response.Status = "OK"

		header := new(DOMAIN.UpdateSkillRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}

	message := "Skill wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Skill = nil
	response.Status = "Error"

	header := new(DOMAIN.UpdateSkillRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

/**
* Function to delete a skill from DeleteSkillRQ
 */
func DeleteSkill(pRequest *DOMAIN.DeleteSkillRQ) *DOMAIN.DeleteSkillRS {
	timeResponse := time.Now()
	response := DOMAIN.DeleteSkillRS{}
	skillToDelete := dao.GetSkillById(pRequest.ID)
	if skillToDelete != nil {
		// Delete in DB
		rowsDeleted, err := dao.DeleteSkill(pRequest.ID)
		if err != nil || rowsDeleted <= 0 {
			message := "Skill wasn't delete"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}

		response.ID = skillToDelete.ID
		response.Name = skillToDelete.Name
		response.Status = "OK"

		header := new(DOMAIN.DeleteSkillRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}
	message := "Skill wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	header := new(DOMAIN.DeleteSkillRS_Header)
	header.RequestDate = time.Now().String()
	responseTime := time.Now().Sub(timeResponse)
	header.ResponseTime = responseTime.String()
	response.Header = header

	return &response
}

func GetSkills(pRequest *DOMAIN.GetSkillsRQ) *DOMAIN.GetSkillsRS {
	timeResponse := time.Now()
	response := DOMAIN.GetSkillsRS{}

	var skills []*DOMAIN.Skill
	if pRequest.Name == nil {
		skills = dao.GetAllSkills()
	} else {
		skills = dao.GetSkillsByName(*pRequest.Name)
	}
	if skills != nil && len(skills) > 0 {

		response.Skills = skills
		// Create response
		response.Status = "OK"

		header := new(DOMAIN.GetSkillsRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	} else {
		message := "Skills wasn't found in DB"
		log.Error(message)
		response.Message = message
		response.Status = "Error"

		header := new(DOMAIN.GetSkillsRS_Header)
		header.RequestDate = time.Now().String()
		responseTime := time.Now().Sub(timeResponse)
		header.ResponseTime = responseTime.String()
		response.Header = header

		return &response
	}
}