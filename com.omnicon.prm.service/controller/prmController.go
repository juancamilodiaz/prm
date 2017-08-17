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
