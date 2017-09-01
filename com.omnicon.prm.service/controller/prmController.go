package controller

import (
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/tool"
)

func ProcessCreateResource(pRequest *domain.CreateResourceRQ) *domain.CreateResourceRS {
	response := tool.CreateResource(pRequest)
	// Return response
	return response
}

func ProcessUpdateResource(pRequest *domain.UpdateResourceRQ) *domain.UpdateResourceRS {
	response := tool.UpdateResource(pRequest)
	// Return response
	return response
}

func ProcessDeleteResource(pRequest *domain.DeleteResourceRQ) *domain.DeleteResourceRS {
	response := tool.DeleteResource(pRequest)
	// Return response
	return response
}

func ProcessCreateProject(pRequest *domain.CreateProjectRQ) *domain.CreateProjectRS {
	response := tool.CreateProject(pRequest)
	// Return response
	return response
}

func ProcessUpdateProject(pRequest *domain.UpdateProjectRQ) *domain.UpdateProjectRS {
	response := tool.UpdateProject(pRequest)
	// Return response
	return response
}

func ProcessDeleteProject(pRequest *domain.DeleteProjectRQ) *domain.DeleteProjectRS {
	response := tool.DeleteProject(pRequest)
	// Return response
	return response
}

func ProcessCreateSkill(pRequest *domain.CreateSkillRQ) *domain.CreateSkillRS {
	response := tool.CreateSkill(pRequest)
	// Return response
	return response
}

func ProcessUpdateSkill(pRequest *domain.UpdateSkillRQ) *domain.UpdateSkillRS {
	response := tool.UpdateSkill(pRequest)
	// Return response
	return response
}

func ProcessDeleteSkill(pRequest *domain.DeleteSkillRQ) *domain.DeleteSkillRS {
	response := tool.DeleteSkill(pRequest)
	// Return response
	return response
}

func ProcessSetSkillToResource(pRequest *domain.SetSkillToResourceRQ) *domain.SetSkillToResourceRS {
	response := tool.SetSkillToResource(pRequest)
	// Return response
	return response
}

func ProcessDeleteSkillToResource(pRequest *domain.DeleteSkillToResourceRQ) *domain.DeleteSkillToResourceRS {
	response := tool.DeleteSkillToResource(pRequest)
	// Return response
	return response
}

func ProcessSetResourceToProject(pRequest *domain.SetResourceToProjectRQ) *domain.SetResourceToProjectRS {
	response := tool.SetResourceToProject(pRequest)
	// Return response
	return response
}
