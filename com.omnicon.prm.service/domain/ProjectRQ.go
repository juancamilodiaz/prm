package domain

type CreateProjectRQ struct {
	Name        string
	StartDate   string
	EndDate     string
	Enabled     bool
	ProjectType []string
}

type DeleteProjectRQ struct {
	ID int64
}

type GetProjectsRQ struct {
	ID          int64
	Name        string
	StartDate   string
	EndDate     string
	Enabled     *bool
	ProjectType []*Type
}

type UpdateProjectRQ struct {
	ID          int64
	Name        string
	StartDate   string
	EndDate     string
	Enabled     bool
	ProjectType []string
}
