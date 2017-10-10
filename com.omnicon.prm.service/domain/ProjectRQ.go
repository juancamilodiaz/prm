package domain

type CreateProjectRQ struct {
	Name            string
	StartDate       string
	EndDate         string
	Enabled         bool
	ProjectType     []string
	OperationCenter string
	WorkOrder       int
}

type DeleteProjectRQ struct {
	ID int64
}

type GetProjectsRQ struct {
	ID              int64
	Name            string
	StartDate       string
	EndDate         string
	Enabled         *bool
	ProjectType     []*Type
	OperationCenter string
	WorkOrder       int
}

type UpdateProjectRQ struct {
	ID              int64
	Name            string
	StartDate       string
	EndDate         string
	Enabled         bool
	OperationCenter string
	WorkOrder       int
	//ProjectType []string
}
