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

func ProcessDeleteResourceToProject(pRequest *domain.DeleteResourceToProjectRQ) *domain.DeleteResourceToProjectRS {
	response := tool.DeleteResourceToProject(pRequest)
	// Return response
	return response
}

func ProcessGetResources(pRequest *domain.GetResourcesRQ) *domain.GetResourcesRS {
	response := tool.GetResources(pRequest)
	// Return response
	return response
}

func ProcessGetProjects(pRequest *domain.GetProjectsRQ) *domain.GetProjectsRS {
	response := tool.GetProjects(pRequest)
	// Return response
	return response
}

func ProcessGetSkills(pRequest *domain.GetSkillsRQ) *domain.GetSkillsRS {
	response := tool.GetSkills(pRequest)
	// Return response
	return response
}

func ProcessGetResourcesToProjects(pRequest *domain.GetResourcesToProjectsRQ) *domain.GetResourcesToProjectsRS {
	response := tool.GetResourcesToProjects(pRequest)
	// Return response
	return response
}

func ProcessGetSkillsToResources(pRequest *domain.GetSkillByResourceRQ) *domain.GetSkillByResourceRS {
	response := tool.GetSkillsToResources(pRequest)
	// Return response
	return response
}

func ProcessGetTypes(pRequest *domain.TypeRQ) *domain.TypeRS {
	return tool.GetTypes(pRequest)
}

func ProcessCreateType(pRequest *domain.TypeRQ) *domain.TypeRS {
	return tool.CreateType(pRequest)
}

func ProcessUpdateType(pRequest *domain.TypeRQ) *domain.TypeRS {
	return tool.UpdateType(pRequest)
}
func ProcessDeleteType(pRequest *domain.TypeRQ) *domain.TypeRS {
	return tool.DeleteType(pRequest)
}

func ProcessGetSkillsByType(pRequest *domain.TypeRQ) *domain.TypeSkillsRS {
	return tool.GetSkillsByType(pRequest)
}

func ProcessGetTypesByProject(pRequest *domain.GetProjectsRQ) *domain.ProjectTypesRS {
	return tool.GetTypesByProject(pRequest)
}

func ProcessDeleteSkillsByType(pRequest *domain.TypeSkillsRQ) *domain.TypeSkillsRS {
	return tool.DeleteSkillsByType(pRequest)
}

func ProcessDeleteTypesByProject(pRequest *domain.ProjectTypesRQ) *domain.ProjectTypesRS {
	return tool.DeleteTypesByProject(pRequest)
}

func ProcessSetSkillsByType(pRequest *domain.TypeSkillsRQ) *domain.TypeSkillsRS {
	return tool.SetSkillsByType(pRequest)
}

func ProcessSetTypesByProject(pRequest *domain.ProjectTypesRQ) *domain.ProjectTypesRS {
	return tool.SetTypesByProject(pRequest)
}

func ProcessGetTrainingResources(pRequest *domain.TrainingResourcesRQ) *domain.TrainingResourcesRS {
	return tool.GetTrainingResources(pRequest)
}

func ProcessGetTrainings(pRequest *domain.TrainingRQ) *domain.TrainingRS {
	return tool.GetTrainings(pRequest)
}

func ProcessCreateTraining(pRequest *domain.TrainingRQ) *domain.TrainingRS {
	return tool.CreateTraining(pRequest)
}

func ProcessUpdateTraining(pRequest *domain.TrainingRQ) *domain.TrainingRS {
	return tool.UpdateTraining(pRequest)
}

func ProcessDeleteTraining(pRequest *domain.TrainingRQ) *domain.TrainingRS {
	return tool.DeleteTraining(pRequest)
}

func ProcessGetTypesByResource(pRequest *domain.GetResourcesRQ) *domain.ResourceTypesRS {
	return tool.GetTypesByResource(pRequest)
}

func ProcessDeleteTypesByResource(pRequest *domain.ResourceTypesRQ) *domain.ResourceTypesRS {
	return tool.DeleteTypesByResource(pRequest)
}

func ProcessSetTypesByResource(pRequest *domain.ResourceTypesRQ) *domain.ResourceTypesRS {
	return tool.SetTypesByResource(pRequest)
}

func ProcessSetTrainingToResource(pRequest *domain.TrainingResourcesRQ) *domain.TrainingResourcesRS {
	return tool.SetTrainingToResource(pRequest)
}
