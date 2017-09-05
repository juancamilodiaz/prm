package tool

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"prm/com.omnicon.prm.service/dao"
	"prm/com.omnicon.prm.service/domain"
)

func init() {
	time.Local = time.UTC
}

func TestCRUDProject(t *testing.T) {
	requestCreateProject := domain.CreateProjectRQ{}
	requestCreateProject.Name = "Project Test"
	requestCreateProject.StartDate = "2017/09/05"
	requestCreateProject.EndDate = "2017/09/10"
	requestCreateProject.Enabled = true

	resultCreateProject := CreateProject(&requestCreateProject)

	assert.NotNil(t, resultCreateProject, "The result is nil.")
	assert.NotNil(t, resultCreateProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultCreateProject.Message, "The message is not empty nil.")
	assert.NotNil(t, resultCreateProject.Project, "The project is nil.")
	assert.Equal(t, "OK", resultCreateProject.Status, "The status is not OK")
	assert.Equal(t, requestCreateProject.Name, resultCreateProject.Project.Name, "The name not changed")
	assert.Equal(t, requestCreateProject.StartDate, resultCreateProject.Project.StartDate, "The StartDate not changed")
	assert.Equal(t, requestCreateProject.EndDate, resultCreateProject.Project.EndDate, "The EndDate not changed")
	assert.Equal(t, requestCreateProject.Enabled, resultCreateProject.Project.Enabled, "The Enabled not changed")

	requestUpdateProject := domain.UpdateProjectRQ{}
	requestUpdateProject.ID = resultCreateProject.Project.ID
	requestUpdateProject.Name = "Project Test 2"
	requestUpdateProject.StartDate = "2017/09/10"
	requestUpdateProject.EndDate = "2017/09/15"
	requestUpdateProject.Enabled = false

	resultUpdateProject := UpdateProject(&requestUpdateProject)

	assert.NotNil(t, resultUpdateProject, "The result is nil.")
	assert.NotNil(t, resultUpdateProject.GetHeader(), "The header of result is nil.")
	assert.Empty(t, resultUpdateProject.Message, "The message is not empty.")
	assert.NotNil(t, resultUpdateProject.Project, "The project is nil.")
	assert.Equal(t, "OK", resultUpdateProject.Status, "The status is not OK")
	assert.Equal(t, requestUpdateProject.Name, resultUpdateProject.Project.Name, "The name not changed")
	assert.Equal(t, requestUpdateProject.StartDate, resultUpdateProject.Project.StartDate, "The StartDate not changed")
	assert.Equal(t, requestUpdateProject.EndDate, resultUpdateProject.Project.EndDate, "The EndDate not changed")
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
