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
	assert.Empty(t, resultCreateResource.Message, "The message is not empty.")
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
	assert.NotEqual(t, int64(0), resultCreateSkill.Skill.ID, "The skill is 0.")
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

	setSkillToResource.Value = 98

	resultSetSkillToResource = SetSkillToResource(&setSkillToResource)

	assert.NotNil(t, resultSetSkillToResource, "The result is nil.")
	assert.NotNil(t, resultSetSkillToResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultSetSkillToResource.Message, "The message is not empty.")
	assert.NotNil(t, resultSetSkillToResource.Resource, "The resource is nil.")
	assert.Equal(t, 98, resultSetSkillToResource.Resource.Skills["Test Skill 1"], "The value is not correct")
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

	requestDeleteSkill := domain.DeleteSkillRQ{}
	requestDeleteSkill.ID = resultCreateSkill.Skill.ID

	resultDeleteSkill := DeleteSkill(&requestDeleteSkill)

	assert.NotNil(t, resultDeleteSkill, "The result is nil.")
	assert.NotNil(t, resultDeleteSkill.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteSkill.Message, "The message is not empty.")
	assert.Equal(t, resultCreateSkill.Skill.ID, resultDeleteSkill.ID, "The ID sin not the same")
	assert.Equal(t, resultCreateSkill.Skill.Name, resultDeleteSkill.Name, "The name sin not the same")
	assert.Equal(t, "OK", resultDeleteSkill.Status, "The status is not OK.")

	requestDeleteResource := domain.DeleteResourceRQ{}
	requestDeleteResource.ID = resultCreateResource.Resource.ID

	resultDeleteResource := DeleteResource(&requestDeleteResource)

	assert.NotNil(t, resultDeleteResource, "The result is nil.")
	assert.NotNil(t, resultDeleteResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteResource.Message, "The message is not empty.")
	assert.Equal(t, resultDeleteResource.Name, resultDeleteSkillToResource.ResourceName, "The name is not the same")
	assert.Equal(t, "OK", resultDeleteResource.Status, "The status is not OK")

}

func TestGetResources(t *testing.T) {
	requestCreateResource := domain.CreateResourceRQ{}
	requestCreateResource.Name = "Test Name"
	requestCreateResource.LastName = "Test LastName"
	requestCreateResource.Email = "email@test1.com"
	requestCreateResource.EngineerRange = "T1"
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
	assert.NotEqual(t, int64(0), resultCreateSkill.Skill.ID, "The skill is 0.")
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

	requestGetResource := domain.GetResourcesRQ{}
	name := "Test Name"
	requestGetResource.Name = name

	resultGetResource := GetResources(&requestGetResource)

	assert.NotNil(t, resultGetResource, "The result is nil.")
	assert.NotNil(t, resultGetResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultGetResource.Message, "The message is not empty.")
	assert.Equal(t, 1, len(resultGetResource.Resources), "The resources list not has the number of resources correct.")
	assert.Equal(t, resultCreateResource.Resource.ID, resultGetResource.Resources[0].ID, "The resources list not has the number of resources correct.")
	assert.Equal(t, "OK", resultGetResource.Status, "The status is not OK")

	requestGetResource.Name = ""
	lastName := "Test LastName"
	requestGetResource.LastName = lastName

	resultGetResource = GetResources(&requestGetResource)

	assert.NotNil(t, resultGetResource, "The result is nil.")
	assert.NotNil(t, resultGetResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultGetResource.Message, "The message is not empty.")
	assert.Equal(t, 1, len(resultGetResource.Resources), "The resources list not has the number of resources correct.")
	assert.Equal(t, resultCreateResource.Resource.ID, resultGetResource.Resources[0].ID, "The resources list not has the number of resources correct.")
	assert.Equal(t, "OK", resultGetResource.Status, "The status is not OK")

	requestGetResource.LastName = ""
	email := "email@test1.com"
	requestGetResource.Email = email

	resultGetResource = GetResources(&requestGetResource)

	assert.NotNil(t, resultGetResource, "The result is nil.")
	assert.NotNil(t, resultGetResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultGetResource.Message, "The message is not empty.")
	assert.Equal(t, 1, len(resultGetResource.Resources), "The resources list not has the number of resources correct.")
	assert.Equal(t, resultCreateResource.Resource.ID, resultGetResource.Resources[0].ID, "The resources list not has the number of resources correct.")
	assert.Equal(t, "OK", resultGetResource.Status, "The status is not OK")

	requestGetResource.Email = ""
	engineerRange := "T1"
	requestGetResource.EngineerRange = engineerRange

	resultGetResource = GetResources(&requestGetResource)

	assert.NotNil(t, resultGetResource, "The result is nil.")
	assert.NotNil(t, resultGetResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultGetResource.Message, "The message is not empty.")
	assert.Equal(t, 1, len(resultGetResource.Resources), "The resources list not has the number of resources correct.")
	assert.Equal(t, resultCreateResource.Resource.ID, resultGetResource.Resources[0].ID, "The resources list not has the number of resources correct.")
	assert.Equal(t, "OK", resultGetResource.Status, "The status is not OK")

	enabled := true
	requestGetResource.Enabled = &enabled

	resultGetResource = GetResources(&requestGetResource)

	assert.NotNil(t, resultGetResource, "The result is nil.")
	assert.NotNil(t, resultGetResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultGetResource.Message, "The message is not empty.")
	assert.Equal(t, 1, len(resultGetResource.Resources), "The resources list not has the number of resources correct.")
	assert.Equal(t, resultCreateResource.Resource.ID, resultGetResource.Resources[0].ID, "The resources list not has the number of resources correct.")
	assert.Equal(t, "OK", resultGetResource.Status, "The status is not OK")

	enabled = false
	requestGetResource.Enabled = &enabled
	requestGetResource.EngineerRange = ""

	resultGetResource = GetResources(&requestGetResource)

	assert.NotNil(t, resultGetResource, "The result is nil.")
	assert.NotNil(t, resultGetResource.GetHeader(), "The header of result is nil.")
	assert.NotEmpty(t, resultGetResource.Message, "The message is empty.")
	assert.Equal(t, 0, len(resultGetResource.Resources), "The resources list not has the number of resources correct.")
	assert.Equal(t, "OK", resultGetResource.Status, "The status is not OK")

	requestGetResource.Name = requestCreateResource.Name
	enabled = true
	requestGetResource.Enabled = &enabled
	mapSkills := make(map[string]int)
	mapSkills["Test Skill 1"] = 99
	requestGetResource.Skills = mapSkills
	resultGetResource = GetResources(&requestGetResource)

	assert.NotNil(t, resultGetResource, "The result is nil.")
	assert.NotNil(t, resultGetResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultGetResource.Message, "The message is not empty.")
	assert.Equal(t, 1, len(resultGetResource.Resources), "The resources list not has the number of resources correct.")
	assert.Equal(t, resultCreateResource.Resource.ID, resultGetResource.Resources[0].ID, "The resources list not has the number of resources correct.")
	assert.Equal(t, "OK", resultGetResource.Status, "The status is not OK")

	requestGetResourceEmpty := domain.GetResourcesRQ{}
	resultGetResource = GetResources(&requestGetResourceEmpty)

	assert.NotNil(t, resultGetResource, "The result is nil.")
	assert.NotNil(t, resultGetResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultGetResource.Message, "The message is not empty.")
	assert.NotEqual(t, 0, len(resultGetResource.Resources), "The resources list not has the number of resources correct.")
	assert.Equal(t, "OK", resultGetResource.Status, "The status is not OK")

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

	requestDeleteSkill := domain.DeleteSkillRQ{}
	requestDeleteSkill.ID = resultCreateSkill.Skill.ID

	resultDeleteSkill := DeleteSkill(&requestDeleteSkill)

	assert.NotNil(t, resultDeleteSkill, "The result is nil.")
	assert.NotNil(t, resultDeleteSkill.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteSkill.Message, "The message is not empty.")
	assert.Equal(t, resultCreateSkill.Skill.ID, resultDeleteSkill.ID, "The ID sin not the same")
	assert.Equal(t, resultCreateSkill.Skill.Name, resultDeleteSkill.Name, "The name sin not the same")
	assert.Equal(t, "OK", resultDeleteSkill.Status, "The status is not OK.")

	requestDeleteResource := domain.DeleteResourceRQ{}
	requestDeleteResource.ID = resultCreateResource.Resource.ID

	resultDeleteResource := DeleteResource(&requestDeleteResource)

	assert.NotNil(t, resultDeleteResource, "The result is nil.")
	assert.NotNil(t, resultDeleteResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteResource.Message, "The message is not empty.")
	assert.Equal(t, resultDeleteResource.Name, resultCreateResource.Resource.Name, "The name is not the same")
	assert.Equal(t, "OK", resultDeleteResource.Status, "The status is not OK")

}

func TestCreateResourceError(t *testing.T) {
	requestCreateResource := domain.CreateResourceRQ{}
	requestCreateResource.Name = "Test Name"
	requestCreateResource.LastName = "Test LastName"
	requestCreateResource.Email = "email@test1.com"
	requestCreateResource.EngineerRange = "E12"
	requestCreateResource.Photo = "/test/path/1"
	requestCreateResource.Enabled = true

	resultCreateResource := CreateResource(&requestCreateResource)

	assert.NotNil(t, resultCreateResource, "The result is nil.")
	assert.Nil(t, resultCreateResource.GetHeader(), "The header of result is not nil.")
	assert.NotEmpty(t, resultCreateResource.Message, "The message is empty.")
	assert.Nil(t, resultCreateResource.Resource, "The resource is not nil.")
	assert.Equal(t, "Error", resultCreateResource.Status, "The status is not Error")
}

func TestUpdateResourceNotFoundError(t *testing.T) {
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

	requestDeleteResource := domain.DeleteResourceRQ{}
	requestDeleteResource.ID = resultCreateResource.Resource.ID

	resultDeleteResource := DeleteResource(&requestDeleteResource)

	assert.NotNil(t, resultDeleteResource, "The result is nil.")
	assert.NotNil(t, resultDeleteResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteResource.Message, "The message is not empty.")
	assert.Equal(t, requestCreateResource.Name, resultDeleteResource.Name, "The name not changed")
	assert.Equal(t, requestCreateResource.LastName, resultDeleteResource.LastName, "The email not changed")
	assert.Equal(t, "OK", resultDeleteResource.Status, "The status is not OK")

	resultGetResourceAfterDelete := dao.GetResourceById(resultDeleteResource.ID)
	assert.Nil(t, resultGetResourceAfterDelete, "The result is not nil.")

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
	assert.NotEmpty(t, resultUpdateResource.Message, "The message is empty.")
	assert.Nil(t, resultUpdateResource.Resource, "The resource is not nil.")
	assert.Equal(t, "Error", resultUpdateResource.Status, "The status is OK")
}

func TestUpdateResourceNotUpdateError(t *testing.T) {
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

	requestUpdateResource := domain.UpdateResourceRQ{}
	requestUpdateResource.ID = resultCreateResource.Resource.ID
	requestUpdateResource.Name = "Test Juan"
	requestUpdateResource.LastName = "Test Diaz"
	requestUpdateResource.Email = "juan@test1.com"
	requestUpdateResource.EngineerRange = "E32"
	requestUpdateResource.Photo = "/test/path/JuanDiaz"
	requestUpdateResource.Enabled = false

	resultUpdateResource := UpdateResource(&requestUpdateResource)

	assert.NotNil(t, resultUpdateResource, "The result is nil.")
	assert.Nil(t, resultUpdateResource.GetHeader(), "The header of result is not nil.")
	assert.NotEmpty(t, resultUpdateResource.Message, "The message is empty.")
	assert.Nil(t, resultUpdateResource.Resource, "The resource is not nil.")
	assert.Equal(t, "Error", resultUpdateResource.Status, "The status is OK")

	requestDeleteResource := domain.DeleteResourceRQ{}
	requestDeleteResource.ID = resultCreateResource.Resource.ID

	resultDeleteResource := DeleteResource(&requestDeleteResource)

	assert.NotNil(t, resultDeleteResource, "The result is nil.")
	assert.NotNil(t, resultDeleteResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteResource.Message, "The message is not empty.")
	assert.Equal(t, requestCreateResource.Name, resultDeleteResource.Name, "The name not changed")
	assert.Equal(t, requestCreateResource.LastName, resultDeleteResource.LastName, "The email not changed")
	assert.Equal(t, "OK", resultDeleteResource.Status, "The status is not OK")

	resultGetResourceAfterDelete := dao.GetResourceById(resultDeleteResource.ID)
	assert.Nil(t, resultGetResourceAfterDelete, "The result is not nil.")

}

func TestDeleteResourceNotFoundError(t *testing.T) {

	requestDeleteResource := domain.DeleteResourceRQ{}
	requestDeleteResource.ID = int64(0)

	resultDeleteResource := DeleteResource(&requestDeleteResource)

	assert.NotNil(t, resultDeleteResource, "The result is nil.")
	assert.NotNil(t, resultDeleteResource.GetHeader(), "The header of result is nil.")
	assert.NotEmpty(t, resultDeleteResource.Message, "The message is empty.")
	assert.Equal(t, "", resultDeleteResource.Name, "The name is in the result")
	assert.Equal(t, "", resultDeleteResource.LastName, "The email is in the result")
	assert.Equal(t, "Error", resultDeleteResource.Status, "The status is OK")
}

func TestSetSkillToResourceErrorSkillNotFound(t *testing.T) {
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

	setSkillToResource := domain.SetSkillToResourceRQ{}
	setSkillToResource.ResourceId = resultCreateResource.Resource.ID
	setSkillToResource.SkillId = int64(0)
	setSkillToResource.Value = 99

	resultSetSkillToResource := SetSkillToResource(&setSkillToResource)

	assert.NotNil(t, resultSetSkillToResource, "The result is nil.")
	assert.NotNil(t, resultSetSkillToResource.GetHeader(), "The header of result is nil.")
	assert.NotEmpty(t, resultSetSkillToResource.Message, "The message is empty.")
	assert.Nil(t, resultSetSkillToResource.Resource, "The resource is not nil.")
	assert.Equal(t, "Error", resultSetSkillToResource.Status, "The status is OK")

	requestDeleteResource := domain.DeleteResourceRQ{}
	requestDeleteResource.ID = resultCreateResource.Resource.ID

	resultDeleteResource := DeleteResource(&requestDeleteResource)

	assert.NotNil(t, resultDeleteResource, "The result is nil.")
	assert.NotNil(t, resultDeleteResource.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteResource.Message, "The message is not empty.")
	assert.Equal(t, resultDeleteResource.Name, resultCreateResource.Resource.Name, "The name is not the same")
	assert.Equal(t, "OK", resultDeleteResource.Status, "The status is not OK")

}

func TestSetSkillToResourceErrorResourceNotFound(t *testing.T) {

	setSkillToResource := domain.SetSkillToResourceRQ{}
	setSkillToResource.ResourceId = int64(0)
	setSkillToResource.SkillId = int64(0)
	setSkillToResource.Value = 99

	resultSetSkillToResource := SetSkillToResource(&setSkillToResource)

	assert.NotNil(t, resultSetSkillToResource, "The result is nil.")
	assert.NotNil(t, resultSetSkillToResource.GetHeader(), "The header of result is nil.")
	assert.NotEmpty(t, resultSetSkillToResource.Message, "The message is empty.")
	assert.Nil(t, resultSetSkillToResource.Resource, "The resource is not nil.")
	assert.Equal(t, "Error", resultSetSkillToResource.Status, "The status is OK")

}

func TestDeleteSkillToResourceErrorResourceNotFound(t *testing.T) {

	deleteSkillToResource := domain.DeleteSkillToResourceRQ{}
	deleteSkillToResource.ResourceId = int64(0)
	deleteSkillToResource.SkillId = int64(0)

	resultDeleteSkillToResource := DeleteSkillToResource(&deleteSkillToResource)

	assert.NotNil(t, resultDeleteSkillToResource, "The result is nil.")
	assert.NotNil(t, resultDeleteSkillToResource.GetHeader(), "The header of result is nil.")
	assert.NotEmpty(t, resultDeleteSkillToResource.Message, "The message is empty.")
	assert.Equal(t, "", resultDeleteSkillToResource.ResourceName, "The resource is not nil.")
	assert.Equal(t, "Error", resultDeleteSkillToResource.Status, "The status is OK")

}
