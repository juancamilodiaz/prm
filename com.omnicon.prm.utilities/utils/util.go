package utils

import (
	"strconv"
	"strings"
	"time"

	"prm/com.omnicon.prm.service/domain"
)

func MappingCreateResource(pRequest *domain.CreateResourceRQ) *domain.Resource {
	return new(domain.Resource)
}

func GenerateID(pResource *domain.Resource) string {
	nameArray := strings.Split(pResource.Name, " ")
	initials := ""

	initials = string(nameArray[0][0])

	return initials + strconv.FormatInt(time.Now().Unix(), 2)
}
