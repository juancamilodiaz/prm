package tool

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"prm/com.omnicon.prm.service/dao"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/util"
)

func init() {
	time.Local = time.UTC
}

func TestCRUDProject(t *testing.T) {
	requestCreateProject := domain.CreateProjectRQ{}
	requestCreateProject.Name = "Project Test"
	requestCreateProject.StartDate = "2017-09-05"
	requestCreateProject.EndDate = "2017-09-10"
	requestCreateProject.Enabled = true

	resultCreateProject := CreateProject(&requestCreateProject)

	assert.NotNil(t, resultCreateProject, "The result is nil.")
	assert.NotNil(t, resultCreateProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateProject.Message, "The message is not empty nil.")
	assert.NotNil(t, resultCreateProject.Project, "The project is nil.")
	assert.Equal(t, "OK", resultCreateProject.Status, "The status is not OK")
	assert.Equal(t, requestCreateProject.Name, resultCreateProject.Project.Name, "The name not changed")
	assert.Equal(t, requestCreateProject.StartDate, util.GetFechaConFormato(resultCreateProject.Project.StartDate.Unix(), util.DATEFORMAT), "The StartDate not changed")
	assert.Equal(t, requestCreateProject.EndDate, util.GetFechaConFormato(resultCreateProject.Project.EndDate.Unix(), util.DATEFORMAT), "The EndDate not changed")
	assert.Equal(t, requestCreateProject.Enabled, resultCreateProject.Project.Enabled, "The Enabled not changed")

	requestGetProjects := new(domain.GetProjectsRQ)
	requestGetProjects.Name = &requestCreateProject.Name
	resultGetProjects := GetProjects(requestGetProjects)

	assert.NotNil(t, resultGetProjects, "The result is nil.")
	assert.NotNil(t, resultGetProjects.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultGetProjects.Message, "The message is not empty.")
	if assert.Len(t, resultGetProjects.Projects, 1, "The project list is empty.") {
		assert.Equal(t, requestCreateProject.Name, resultGetProjects.Projects[0].Name, "The name not changed")
		assert.Equal(t, requestCreateProject.StartDate, util.GetFechaConFormato(resultGetProjects.Projects[0].StartDate.Unix(), util.DATEFORMAT), "The StartDate not changed")
		assert.Equal(t, requestCreateProject.EndDate, util.GetFechaConFormato(resultGetProjects.Projects[0].EndDate.Unix(), util.DATEFORMAT), "The EndDate not changed")
		assert.Equal(t, requestCreateProject.Enabled, resultGetProjects.Projects[0].Enabled, "The Enabled not changed")

	}
	assert.Equal(t, "OK", resultGetProjects.Status, "The status is not OK")

	requestUpdateProject := domain.UpdateProjectRQ{}
	requestUpdateProject.ID = resultCreateProject.Project.ID
	requestUpdateProject.Name = "Project Test 2"
	requestUpdateProject.StartDate = "2017-09-10"
	requestUpdateProject.EndDate = "2017-09-15"
	requestUpdateProject.Enabled = false

	resultUpdateProject := UpdateProject(&requestUpdateProject)

	assert.NotNil(t, resultUpdateProject, "The result is nil.")
	assert.NotNil(t, resultUpdateProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultUpdateProject.Message, "The message is not empty.")
	assert.NotNil(t, resultUpdateProject.Project, "The project is nil.")
	assert.Equal(t, "OK", resultUpdateProject.Status, "The status is not OK")
	assert.Equal(t, requestUpdateProject.Name, resultUpdateProject.Project.Name, "The name not changed")
	assert.Equal(t, requestUpdateProject.StartDate, util.GetFechaConFormato(resultUpdateProject.Project.StartDate.Unix(), util.DATEFORMAT), "The StartDate not changed")
	assert.Equal(t, requestUpdateProject.EndDate, util.GetFechaConFormato(resultUpdateProject.Project.EndDate.Unix(), util.DATEFORMAT), "The EndDate not changed")
	assert.Equal(t, requestUpdateProject.Enabled, resultUpdateProject.Project.Enabled, "The Enabled not changed")

	requestDeleteProject := domain.DeleteProjectRQ{}
	requestDeleteProject.ID = resultUpdateProject.Project.ID

	resultDeleteProject := DeleteProject(&requestDeleteProject)

	assert.NotNil(t, resultDeleteProject, "The result is nil.")
	assert.NotNil(t, resultDeleteProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteProject.Message, "The message is not empty.")
	assert.Equal(t, resultDeleteProject.ID, resultDeleteProject.ID, "The name not changed")
	assert.Equal(t, resultDeleteProject.Name, resultDeleteProject.Name, "The email not changed")
	assert.Equal(t, "OK", resultDeleteProject.Status, "The status is not OK")

	resultGetProjectAfterDelete := dao.GetProjectById(resultDeleteProject.ID)
	assert.Nil(t, resultGetProjectAfterDelete, "The result is not nil.")

}

func TestSetResourceToProject(t *testing.T) {
	requestCreateProject := domain.CreateProjectRQ{}
	requestCreateProject.Name = "Project Test Set Resource"
	requestCreateProject.StartDate = "2017-09-05"
	requestCreateProject.EndDate = "2017-09-10"
	requestCreateProject.Enabled = true

	resultCreateProject := CreateProject(&requestCreateProject)

	assert.NotNil(t, resultCreateProject, "The result is nil.")
	assert.NotNil(t, resultCreateProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateProject.Message, "The message is not empty nil.")
	assert.NotNil(t, resultCreateProject.Project, "The project is nil.")
	assert.Equal(t, "OK", resultCreateProject.Status, "The status is not OK")
	assert.Equal(t, requestCreateProject.Name, resultCreateProject.Project.Name, "The name not changed")
	assert.Equal(t, requestCreateProject.StartDate, util.GetFechaConFormato(resultCreateProject.Project.StartDate.Unix(), util.DATEFORMAT), "The StartDate not changed")
	assert.Equal(t, requestCreateProject.EndDate, util.GetFechaConFormato(resultCreateProject.Project.EndDate.Unix(), util.DATEFORMAT), "The EndDate not changed")
	assert.Equal(t, requestCreateProject.Enabled, resultCreateProject.Project.Enabled, "The Enabled not changed")

	requestCreateResource := domain.CreateResourceRQ{}
	requestCreateResource.Name = "Resource Test Set Resource"
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

	//////////////////////

	requestSetResourceToProject := new(domain.SetResourceToProjectRQ)
	requestSetResourceToProject.ProjectId = resultCreateProject.Project.ID
	requestSetResourceToProject.ResourceId = resultCreateResource.Resource.ID
	requestSetResourceToProject.StartDate = "2017-09-06"
	requestSetResourceToProject.EndDate = "2017-09-09"
	requestSetResourceToProject.Lead = true

	responseSetResourceToProject := SetResourceToProject(requestSetResourceToProject)

	assert.NotNil(t, responseSetResourceToProject, "The result is nil.")
	assert.NotNil(t, responseSetResourceToProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, responseSetResourceToProject.Message, "The message is not empty.")
	assert.Equal(t, "OK", responseSetResourceToProject.Status, "The status is not OK")
	assert.NotNil(t, "OK", responseSetResourceToProject.Project, "The project is nil")
	assert.Equal(t, responseSetResourceToProject.Project.Name, resultCreateProject.Project.Name)
	assert.Equal(t, responseSetResourceToProject.Project.Lead, resultCreateResource.Resource.Name)

	//////////////////////

	requestDeleteResourceToProject := new(domain.DeleteResourceToProjectRQ)
	requestDeleteResourceToProject.ProjectId = resultCreateProject.Project.ID
	requestDeleteResourceToProject.ResourceId = resultCreateResource.Resource.ID

	responseDeleteResourceToProject := DeleteResourceToProject(requestDeleteResourceToProject)

	assert.NotNil(t, responseDeleteResourceToProject, "The result is nil.")
	assert.NotNil(t, responseDeleteResourceToProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, responseDeleteResourceToProject.Message, "The message is not empty.")
	assert.Equal(t, "OK", responseDeleteResourceToProject.Status, "The status is not OK")
	assert.Equal(t, responseDeleteResourceToProject.ProjectName, resultCreateProject.Project.Name)
	assert.Equal(t, responseDeleteResourceToProject.ResourceName, resultCreateResource.Resource.Name)

	//////////////////////

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

	requestDeleteProject := domain.DeleteProjectRQ{}
	requestDeleteProject.ID = resultCreateProject.Project.ID

	resultDeleteProject := DeleteProject(&requestDeleteProject)

	assert.NotNil(t, resultDeleteProject, "The result is nil.")
	assert.NotNil(t, resultDeleteProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteProject.Message, "The message is not empty.")
	assert.Equal(t, resultDeleteProject.ID, resultDeleteProject.ID, "The name not changed")
	assert.Equal(t, resultDeleteProject.Name, resultDeleteProject.Name, "The email not changed")
	assert.Equal(t, "OK", resultDeleteProject.Status, "The status is not OK")

	resultGetProjectAfterDelete := dao.GetProjectById(resultDeleteProject.ID)
	assert.Nil(t, resultGetProjectAfterDelete, "The result is not nil.")
}

func TestUpdateResourceToProject(t *testing.T) {
	requestCreateProject := domain.CreateProjectRQ{}
	requestCreateProject.Name = "Project Test Set Resource"
	requestCreateProject.StartDate = "2017-09-05"
	requestCreateProject.EndDate = "2017-09-10"
	requestCreateProject.Enabled = true

	resultCreateProject := CreateProject(&requestCreateProject)

	assert.NotNil(t, resultCreateProject, "The result is nil.")
	assert.NotNil(t, resultCreateProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateProject.Message, "The message is not empty nil.")
	assert.NotNil(t, resultCreateProject.Project, "The project is nil.")
	assert.Equal(t, "OK", resultCreateProject.Status, "The status is not OK")
	assert.Equal(t, requestCreateProject.Name, resultCreateProject.Project.Name, "The name not changed")
	assert.Equal(t, requestCreateProject.StartDate, util.GetFechaConFormato(resultCreateProject.Project.StartDate.Unix(), util.DATEFORMAT), "The StartDate not changed")
	assert.Equal(t, requestCreateProject.EndDate, util.GetFechaConFormato(resultCreateProject.Project.EndDate.Unix(), util.DATEFORMAT), "The EndDate not changed")
	assert.Equal(t, requestCreateProject.Enabled, resultCreateProject.Project.Enabled, "The Enabled not changed")

	requestCreateResource := domain.CreateResourceRQ{}
	requestCreateResource.Name = "Resource Test Set Resource"
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

	//////////////////////

	requestSetResourceToProject := new(domain.SetResourceToProjectRQ)
	requestSetResourceToProject.ProjectId = resultCreateProject.Project.ID
	requestSetResourceToProject.ResourceId = resultCreateResource.Resource.ID
	requestSetResourceToProject.StartDate = "2017-09-06"
	requestSetResourceToProject.EndDate = "2017-09-09"
	requestSetResourceToProject.Lead = true

	responseSetResourceToProject := SetResourceToProject(requestSetResourceToProject)

	assert.NotNil(t, responseSetResourceToProject, "The result is nil.")
	assert.NotNil(t, responseSetResourceToProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, responseSetResourceToProject.Message, "The message is not empty.")
	assert.Equal(t, "OK", responseSetResourceToProject.Status, "The status is not OK")
	assert.NotNil(t, "OK", responseSetResourceToProject.Project, "The project is nil")
	assert.Equal(t, responseSetResourceToProject.Project.Name, resultCreateProject.Project.Name)
	assert.Equal(t, responseSetResourceToProject.Project.Lead, resultCreateResource.Resource.Name)

	requestSetResourceToProject = new(domain.SetResourceToProjectRQ)
	requestSetResourceToProject.ProjectId = resultCreateProject.Project.ID
	requestSetResourceToProject.ResourceId = resultCreateResource.Resource.ID
	requestSetResourceToProject.StartDate = "2017-09-07"
	requestSetResourceToProject.EndDate = "2017-09-08"
	requestSetResourceToProject.Lead = false

	responseSetResourceToProject = SetResourceToProject(requestSetResourceToProject)

	assert.NotNil(t, responseSetResourceToProject, "The result is nil.")
	assert.NotNil(t, responseSetResourceToProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, responseSetResourceToProject.Message, "The message is not empty.")
	assert.Equal(t, "OK", responseSetResourceToProject.Status, "The status is not OK")
	assert.NotNil(t, "OK", responseSetResourceToProject.Project, "The project is nil")
	assert.Equal(t, responseSetResourceToProject.Project.Name, resultCreateProject.Project.Name)
	assert.Equal(t, "", responseSetResourceToProject.Project.Lead)

	//////////////////////

	requestDeleteResourceToProject := new(domain.DeleteResourceToProjectRQ)
	requestDeleteResourceToProject.ProjectId = resultCreateProject.Project.ID
	requestDeleteResourceToProject.ResourceId = resultCreateResource.Resource.ID

	responseDeleteResourceToProject := DeleteResourceToProject(requestDeleteResourceToProject)

	assert.NotNil(t, responseDeleteResourceToProject, "The result is nil.")
	assert.NotNil(t, responseDeleteResourceToProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, responseDeleteResourceToProject.Message, "The message is not empty.")
	assert.Equal(t, "OK", responseDeleteResourceToProject.Status, "The status is not OK")
	assert.Equal(t, responseDeleteResourceToProject.ProjectName, resultCreateProject.Project.Name)
	assert.Equal(t, responseDeleteResourceToProject.ResourceName, resultCreateResource.Resource.Name)

	//////////////////////

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

	requestDeleteProject := domain.DeleteProjectRQ{}
	requestDeleteProject.ID = resultCreateProject.Project.ID

	resultDeleteProject := DeleteProject(&requestDeleteProject)

	assert.NotNil(t, resultDeleteProject, "The result is nil.")
	assert.NotNil(t, resultDeleteProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteProject.Message, "The message is not empty.")
	assert.Equal(t, resultDeleteProject.ID, resultDeleteProject.ID, "The name not changed")
	assert.Equal(t, resultDeleteProject.Name, resultDeleteProject.Name, "The email not changed")
	assert.Equal(t, "OK", resultDeleteProject.Status, "The status is not OK")

	resultGetProjectAfterDelete := dao.GetProjectById(resultDeleteProject.ID)
	assert.Nil(t, resultGetProjectAfterDelete, "The result is not nil.")
}

func TestGetProjectWithResourcesAndSkills(t *testing.T) {
	requestCreateProject := domain.CreateProjectRQ{}
	requestCreateProject.Name = "Project Test Set Resource"
	requestCreateProject.StartDate = "2017-09-05"
	requestCreateProject.EndDate = "2017-09-10"
	requestCreateProject.Enabled = true

	resultCreateProject := CreateProject(&requestCreateProject)

	assert.NotNil(t, resultCreateProject, "The result is nil.")
	assert.NotNil(t, resultCreateProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateProject.Message, "The message is not empty nil.")
	assert.NotNil(t, resultCreateProject.Project, "The project is nil.")
	assert.Equal(t, "OK", resultCreateProject.Status, "The status is not OK")
	assert.Equal(t, requestCreateProject.Name, resultCreateProject.Project.Name, "The name not changed")
	assert.Equal(t, requestCreateProject.StartDate, util.GetFechaConFormato(resultCreateProject.Project.StartDate.Unix(), util.DATEFORMAT), "The StartDate not changed")
	assert.Equal(t, requestCreateProject.EndDate, util.GetFechaConFormato(resultCreateProject.Project.EndDate.Unix(), util.DATEFORMAT), "The EndDate not changed")
	assert.Equal(t, requestCreateProject.Enabled, resultCreateProject.Project.Enabled, "The Enabled not changed")

	requestCreateResource := domain.CreateResourceRQ{}
	requestCreateResource.Name = "Resource Test Set Resource"
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

	//////////////////////

	requestSetResourceToProject := new(domain.SetResourceToProjectRQ)
	requestSetResourceToProject.ProjectId = resultCreateProject.Project.ID
	requestSetResourceToProject.ResourceId = resultCreateResource.Resource.ID
	requestSetResourceToProject.StartDate = "2017-09-06"
	requestSetResourceToProject.EndDate = "2017-09-09"
	requestSetResourceToProject.Lead = true

	responseSetResourceToProject := SetResourceToProject(requestSetResourceToProject)

	assert.NotNil(t, responseSetResourceToProject, "The result is nil.")
	assert.NotNil(t, responseSetResourceToProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, responseSetResourceToProject.Message, "The message is not empty.")
	assert.Equal(t, "OK", responseSetResourceToProject.Status, "The status is not OK")
	assert.NotNil(t, "OK", responseSetResourceToProject.Project, "The project is nil")
	assert.Equal(t, responseSetResourceToProject.Project.Name, resultCreateProject.Project.Name)
	assert.Equal(t, responseSetResourceToProject.Project.Lead, resultCreateResource.Resource.Name)

	//////////////////////

	requestDeleteResourceToProject := new(domain.DeleteResourceToProjectRQ)
	requestDeleteResourceToProject.ProjectId = resultCreateProject.Project.ID
	requestDeleteResourceToProject.ResourceId = resultCreateResource.Resource.ID

	responseDeleteResourceToProject := DeleteResourceToProject(requestDeleteResourceToProject)

	assert.NotNil(t, responseDeleteResourceToProject, "The result is nil.")
	assert.NotNil(t, responseDeleteResourceToProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, responseDeleteResourceToProject.Message, "The message is not empty.")
	assert.Equal(t, "OK", responseDeleteResourceToProject.Status, "The status is not OK")
	assert.Equal(t, responseDeleteResourceToProject.ProjectName, resultCreateProject.Project.Name)
	assert.Equal(t, responseDeleteResourceToProject.ResourceName, resultCreateResource.Resource.Name)

	//////////////////////

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
	assert.Equal(t, requestCreateResource.Name, resultDeleteResource.Name, "The name not changed")
	assert.Equal(t, requestCreateResource.LastName, resultDeleteResource.LastName, "The email not changed")
	assert.Equal(t, "OK", resultDeleteResource.Status, "The status is not OK")

	resultGetResourceAfterDelete := dao.GetResourceById(resultDeleteResource.ID)
	assert.Nil(t, resultGetResourceAfterDelete, "The result is not nil.")

	requestDeleteProject := domain.DeleteProjectRQ{}
	requestDeleteProject.ID = resultCreateProject.Project.ID

	resultDeleteProject := DeleteProject(&requestDeleteProject)

	assert.NotNil(t, resultDeleteProject, "The result is nil.")
	assert.NotNil(t, resultDeleteProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultDeleteProject.Message, "The message is not empty.")
	assert.Equal(t, resultDeleteProject.ID, resultDeleteProject.ID, "The name not changed")
	assert.Equal(t, resultDeleteProject.Name, resultDeleteProject.Name, "The email not changed")
	assert.Equal(t, "OK", resultDeleteProject.Status, "The status is not OK")

	resultGetProjectAfterDelete := dao.GetProjectById(resultDeleteProject.ID)
	assert.Nil(t, resultGetProjectAfterDelete, "The result is not nil.")
}
