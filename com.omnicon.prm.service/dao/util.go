package dao

import (
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/util"
)

/**
* Function to mapping resources in a project entity.
 */
func MappingResourcesInAProject(pProject *domain.Project, pProjectResources []*domain.ProjectResources) string {
	var lead string
	mapResources := make(map[int]*domain.ResourceAssign, len(pProjectResources))
	for _, projectResource := range pProjectResources {
		resourceAssign := domain.ResourceAssign{}
		resourceAssign.Resource = GetResourceById(projectResource.ResourceId)
		skills := GetResourceSkillsByResourceId(projectResource.ResourceId)
		util.MappingSkillsInAResource(resourceAssign.Resource, skills)
		resourceAssign.StartDate = projectResource.StartDate
		resourceAssign.EndDate = projectResource.EndDate
		resourceAssign.Lead = projectResource.Lead
		if projectResource.Lead {
			lead = resourceAssign.Resource.Name
		} else if pProject.Lead == resourceAssign.Resource.Name {
			lead = ""
		}
		resourceAssign.Hours = projectResource.Hours
		mapResources[projectResource.ID] = &resourceAssign
	}
	pProject.ResourceAssign = mapResources

	return lead
}
