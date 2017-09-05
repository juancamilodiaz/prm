package tool

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"

	"prm/com.omnicon.prm.service/dao"
	"prm/com.omnicon.prm.service/domain"
)

func init() {
	// Se establece la zona horaria local a UTC para que al utilizar
	// los metodos de time.Parse o time.Unix cambie la fecha por la diferencia horaria
	// TODO validar zona horaria por defecto
	time.Local = time.UTC

}

func TestCRUDResource(t *testing.T) {
	requestCreateResource := domain.CreateResourceRQ{}
	requestCreateResource.Name = "Test Name"
	requestCreateResource.LastName = "Test LastName"
	requestCreateResource.Email = "email@test1.com"
	requestCreateResource.EngineerRange = "E1"
	requestCreateResource.Photo = "/test/path/1"
	requestCreateResource.Enabled = true

	resultCreateResource := CreateResource(&requestCreateResource)

	assert.NotNil(t, resultCreateResource, "The result is nil.")
	assert.NotNil(t, resultCreateResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateResource.Message, "The message is not empty nil.")
	assert.NotNil(t, resultCreateResource.Resource, "The resource is nil.")
	assert.Equal(t, "OK", resultCreateResource.Status, "The status is not OK")

	requestUpdateResource := domain.UpdateResourceRQ{}
	requestUpdateResource.ID = resultCreateResource.Resource.ID
	requestUpdateResource.Name = "Test Juan"
	requestUpdateResource.LastName = "Test Diaz"
	requestUpdateResource.Email = "juan@test1.com"
	requestUpdateResource.EngineerRange = "E3"
	requestUpdateResource.Photo = "/test/path/JuanDiaz"
	requestUpdateResource.Enabled = false

	resultUpdateResource := UpdateResource(&requestUpdateResource)

	assert.NotNil(t, resultUpdateResource, "The result is nil.")
	assert.NotNil(t, resultUpdateResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultUpdateResource.Message, "The message is not empty.")
	assert.NotNil(t, resultUpdateResource.Resource, "The resource is nil.")
	assert.Equal(t, "OK", resultUpdateResource.Status, "The status is not OK")
	assert.Equal(t, requestUpdateResource.Name, resultUpdateResource.Resource.Name, "The name not changed")
	assert.Equal(t, requestUpdateResource.Email, resultUpdateResource.Resource.Email, "The email not changed")

	requestDeleteResource := domain.DeleteResourceRQ{}
	requestDeleteResource.ID = resultUpdateResource.Resource.ID

	resultDeleteResource := DeleteResource(&requestDeleteResource)

	assert.NotNil(t, resultDeleteResource, "The result is nil.")
	assert.NotNil(t, resultDeleteResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteResource.Message, "The message is not empty.")
	assert.Equal(t, requestUpdateResource.Name, resultDeleteResource.Name, "The name not changed")
	assert.Equal(t, requestUpdateResource.LastName, resultDeleteResource.LastName, "The email not changed")
	assert.Equal(t, "OK", resultDeleteResource.Status, "The status is not OK")

	resultGetResourceAfterDelete := dao.GetResourceById(resultDeleteResource.ID)
	assert.Nil(t, resultGetResourceAfterDelete, "The result is not nil.")

}

func TestSetSkillToResource(t *testing.T) {
	requestCreateResource := domain.CreateResourceRQ{}
	requestCreateResource.Name = "Test Name"
	requestCreateResource.LastName = "Test LastName"
	requestCreateResource.Email = "email@test1.com"
	requestCreateResource.EngineerRange = "E1"
	requestCreateResource.Photo = "/test/path/1"
	requestCreateResource.Enabled = true

	resultCreateResource := CreateResource(&requestCreateResource)

	assert.NotNil(t, resultCreateResource, "The result is nil.")
	assert.NotNil(t, resultCreateResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateResource.Message, "The message is not empty.")
	assert.NotNil(t, resultCreateResource.Resource, "The resource is nil.")
	assert.Equal(t, "OK", resultCreateResource.Status, "The status is not OK")

	requestCreateSkill := domain.CreateSkillRQ{}
	requestCreateSkill.Name = "Test Skill 1"

	resultCreateSkill := CreateSkill(&requestCreateSkill)

	assert.NotNil(t, resultCreateSkill, "The result is nil.")
	assert.NotNil(t, resultCreateSkill.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateSkill.Message, "The message is not empty.")
	assert.NotNil(t, resultCreateSkill.Skill, "The skill is nil.")
	assert.Equal(t, "OK", resultCreateSkill.Status, "The status is not OK")

	setSkillToResource := domain.SetSkillToResourceRQ{}
	setSkillToResource.ResourceId = resultCreateResource.Resource.ID
	setSkillToResource.SkillId = resultCreateSkill.Skill.ID
	setSkillToResource.Value = 99

	resultSetSkillToResource := SetSkillToResource(&setSkillToResource)

	assert.NotNil(t, resultSetSkillToResource, "The result is nil.")
	assert.NotNil(t, resultSetSkillToResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultSetSkillToResource.Message, "The message is not empty.")
	assert.NotNil(t, resultSetSkillToResource.Resource, "The resource is nil.")
	assert.Equal(t, 99, resultSetSkillToResource.Resource.Skills["Test Skill 1"], "The value is not correct")
	assert.Equal(t, "OK", resultSetSkillToResource.Status, "The status is not OK")

	requestDeleteSkillToResource := domain.DeleteSkillToResourceRQ{}
	requestDeleteSkillToResource.ResourceId = resultCreateResource.Resource.ID
	requestDeleteSkillToResource.SkillId = resultCreateSkill.Skill.ID

	resultDeleteSkillToResource := DeleteSkillToResource(&requestDeleteSkillToResource)

	assert.NotNil(t, resultDeleteSkillToResource, "The result is nil.")
	assert.NotNil(t, resultDeleteSkillToResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteSkillToResource.Message, "The message is not empty.")
	assert.Equal(t, resultCreateResource.Resource.Name, resultDeleteSkillToResource.ResourceName, "The name is not the same")
	assert.Equal(t, resultCreateSkill.Skill.Name, resultDeleteSkillToResource.SkillName, "The name is not the same")
	assert.Equal(t, "OK", resultDeleteSkillToResource.Status, "The status is not OK")

	requestDeleteResource := domain.DeleteResourceRQ{}
	requestDeleteResource.ID = resultCreateResource.Resource.ID

	resultDeleteResource := DeleteResource(&requestDeleteResource)

	assert.NotNil(t, resultDeleteResource, "The result is nil.")
	assert.NotNil(t, resultDeleteResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteResource.Message, "The message is not empty.")
	assert.Equal(t, resultDeleteResource.Name, resultDeleteSkillToResource.ResourceName, "The name is not the same")
	assert.Equal(t, "OK", resultDeleteResource.Status, "The status is not OK")

}
