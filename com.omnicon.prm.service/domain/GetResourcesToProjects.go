package domain

type GetResourcesToProjectsRQ struct {
	ID         *int64
	ProjectId  *int64
	ResourceId *int64
	StartDate  *string
	EndDate    *string
	Lead       *bool
}
