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
