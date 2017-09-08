package domain

type CreateResourceRQ struct {
	Name          string
	LastName      string
	Email         string
	Photo         string
	EngineerRange string
	Enabled       bool
}

type DeleteResourceRQ struct {
	ID int64
}

type GetResourcesRQ struct {
	ID            *int64
	Name          *string
	LastName      *string
	Email         *string
	EngineerRange *string
	Enabled       *bool
	Skills        map[string]int
}

type SetResourceToProjectRQ struct {
	ProjectId  int64
	ResourceId int64
	StartDate  string
	EndDate    string
	Lead       bool
}

type GetResourcesToProjectsRQ struct {
	ID         *int64 `form:"ID"`
	ProjectId  *int64 `form:"ProjectId"`
	ResourceId *int64
	StartDate  *string
	EndDate    *string
	Lead       *bool
}

type DeleteResourceToProjectRQ struct {
	ProjectId  int64
	ResourceId int64
}

type UpdateResourceRQ struct {
	ID            int64
	Name          string
	LastName      string
	Email         string
	Photo         string
	EngineerRange string
	Enabled       bool
}