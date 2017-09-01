package domain

type SetResourceToProjectRQ struct {
	ProjectId  int64
	ResourceId int64
	StartDate  string
	EndDate    string
	Lead       bool
}
