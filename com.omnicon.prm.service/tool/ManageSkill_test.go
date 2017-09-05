package tool

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"prm/com.omnicon.prm.service/domain"
)

func init() {
	time.Local = time.UTC
}

func TestCRUDSkill(t *testing.T) {
	requestCreateSkill := domain.CreateSkillRQ{}
	requestCreateSkill.Name = "Test Skill"

	resultCreateSkill := CreateSkill(&requestCreateSkill)

	assert.NotNil(t, resultCreateSkill, "The result is nil.")
	assert.NotNil(t, resultCreateSkill.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateSkill.Message, "The message is not empty.")
	assert.NotNil(t, resultCreateSkill.Skill, "The skill is nil.")
	assert.Equal(t, "Test Skill", resultCreateSkill.Skill.Name, "The name is not the same")
	assert.Equal(t, "OK", resultCreateSkill.Status, "The status is Error")

	requestUpdateSkill := domain.UpdateSkillRQ{}
	requestUpdateSkill.ID = resultCreateSkill.Skill.ID
	requestUpdateSkill.Name = "Skill Test"

	resultUpdateSkill := UpdateSkill(&requestUpdateSkill)

	assert.NotNil(t, resultUpdateSkill, "The result is nil.")
	assert.NotNil(t, resultUpdateSkill.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultUpdateSkill.Message, "The message is not empty.")
	assert.NotNil(t, resultUpdateSkill.Skill, "The skill is nil.")
	assert.Equal(t, "Skill Test", resultUpdateSkill.Skill.Name, "The name is not the same")
	assert.Equal(t, "OK", resultUpdateSkill.Status, "The status is Error")

	requestDeleteSkill := domain.DeleteSkillRQ{}
	requestDeleteSkill.ID = resultUpdateSkill.Skill.ID

	resultDeleteSkill := DeleteSkill(&requestDeleteSkill)

	assert.NotNil(t, resultDeleteSkill, "The result is nil.")
	assert.NotNil(t, resultDeleteSkill.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteSkill.Message, "The message is not empty.")
	assert.Equal(t, requestUpdateSkill.ID, resultDeleteSkill.ID, "The id is not the same")
	assert.Equal(t, requestUpdateSkill.Name, resultDeleteSkill.Name, "The name is not the same")
	assert.Equal(t, "OK", resultDeleteSkill.Status, "The status is Error")
}

func TestUpdateSkillError(t *testing.T) {

	requestCreateSkill := domain.CreateSkillRQ{}
	requestCreateSkill.Name = "Test Skill"

	resultCreateSkill := CreateSkill(&requestCreateSkill)

	assert.NotNil(t, resultCreateSkill, "The result is nil.")
	assert.NotNil(t, resultCreateSkill.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateSkill.Message, "The message is not empty.")
	assert.NotNil(t, resultCreateSkill.Skill, "The skill is nil.")
	assert.Equal(t, "Test Skill", resultCreateSkill.Skill.Name, "The name is not the same")
	assert.Equal(t, "OK", resultCreateSkill.Status, "The status is Error")

	requestUpdateSkill := domain.UpdateSkillRQ{}
	requestUpdateSkill.ID = resultCreateSkill.Skill.ID
	requestUpdateSkill.Name = "123456789101112131415161718192021222324252627282930"

	resultUpdateSkill := UpdateSkill(&requestUpdateSkill)

	assert.NotNil(t, resultUpdateSkill, "The result is nil.")
	assert.Nil(t, resultUpdateSkill.GetHeader(), "The header of result is not nil.")
	assert.NotEmpty(t, resultUpdateSkill.Message, "The message is empty.")
	assert.Nil(t, resultUpdateSkill.Skill, "The skill is not nil.")
	assert.Equal(t, "Error", resultUpdateSkill.Status, "The status is not Error")

	requestDeleteSkill := domain.DeleteSkillRQ{}
	requestDeleteSkill.ID = resultCreateSkill.Skill.ID

	resultDeleteSkill := DeleteSkill(&requestDeleteSkill)

	assert.NotNil(t, resultDeleteSkill, "The result is nil.")
	assert.NotNil(t, resultDeleteSkill.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteSkill.Message, "The message is not empty.")
	assert.Equal(t, resultCreateSkill.Skill.ID, resultDeleteSkill.ID, "The id is not the same")
	assert.Equal(t, resultCreateSkill.Skill.Name, resultDeleteSkill.Name, "The name is not the same")
	assert.Equal(t, "OK", resultDeleteSkill.Status, "The status is Error")
}

func TestCreateSkillNotFoundError(t *testing.T) {
	requestCreateSkill := domain.CreateSkillRQ{}
	requestCreateSkill.Name = "123456789101112131415161718192021222324252627282930"

	resultCreateSkill := CreateSkill(&requestCreateSkill)

	assert.NotNil(t, resultCreateSkill, "The result is nil.")
	assert.Nil(t, resultCreateSkill.GetHeader(), "The header of result is not nil.")
	assert.NotEmpty(t, resultCreateSkill.Message, "The message is empty.")
	assert.Nil(t, resultCreateSkill.Skill, "The skill is not nil.")
	assert.Equal(t, "Error", resultCreateSkill.Status, "The status is not Error")
}

func TestUpdateSkillNotFoundError(t *testing.T) {
	requestUpdateSkill := domain.UpdateSkillRQ{}
	requestUpdateSkill.ID = int64(0)
	requestUpdateSkill.Name = "Test Skill"

	resultUpdateSkill := UpdateSkill(&requestUpdateSkill)

	assert.NotNil(t, resultUpdateSkill, "The result is nil.")
	assert.NotNil(t, resultUpdateSkill.GetHeader(), "The header of result is nil.")
	assert.NotEmpty(t, resultUpdateSkill.Message, "The message is empty.")
	assert.Nil(t, resultUpdateSkill.Skill, "The skill is not nil.")
	assert.Equal(t, "Error", resultUpdateSkill.Status, "The status is not Error")
}

func TestDeleteSkillNotFoundError(t *testing.T) {
	requestDeleteSkillResource := domain.DeleteSkillRQ{}
	requestDeleteSkillResource.ID = int64(0)

	resultDeleteSkill := DeleteSkill(&requestDeleteSkillResource)

	assert.NotNil(t, resultDeleteSkill, "The result is nil.")
	assert.NotNil(t, resultDeleteSkill.GetHeader(), "The header of result is nil.")
	assert.NotEmpty(t, resultDeleteSkill.Message, "The message is empty.")
	assert.Equal(t, "", resultDeleteSkill.Name, "The name is not empty.")
	assert.Equal(t, "Error", resultDeleteSkill.Status, "The status is not Error")
}

func TestGetSkills(t *testing.T) {
	requestGetSkills := domain.GetSkillsRQ{}

	resultGetSkills := GetSkills(&requestGetSkills)

	assert.NotNil(t, resultGetSkills, "The result is nil.")
	assert.NotNil(t, resultGetSkills.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultGetSkills.Message, "The message is not empty.")
	assert.NotNil(t, resultGetSkills.Skills, "The skills are nil.")
	assert.NotEqual(t, 0, len(resultGetSkills.Skills), "The skills are 0.")
	assert.Equal(t, "OK", resultGetSkills.Status, "The status is Error")
}
