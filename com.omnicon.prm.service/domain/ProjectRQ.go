package domain

type CreateProjectRQ struct {
	Name            string
	StartDate       string
	EndDate         string
	Enabled         bool
	ProjectType     []string
	OperationCenter string
	WorkOrder       int
	LeaderID        int
	Cost            float64
}

type DeleteProjectRQ struct {
	ID int
}

type GetProjectsRQ struct {
	ID              int
	Name            string
	StartDate       string
	EndDate         string
	Enabled         *bool
	ProjectType     []*Type
	OperationCenter string
	WorkOrder       int
}

type UpdateProjectRQ struct {
	ID              int
	Name            string
	StartDate       string
	EndDate         string
	Enabled         bool
	OperationCenter string
	WorkOrder       int
	LeaderID        int
	Cost            float64
}
