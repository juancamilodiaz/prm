package domain

type CreateProjectRQ struct {
	Name      string
	StartDate string
	EndDate   string
	Enabled   bool
}

type DeleteProjectRQ struct {
	ID int64
}

type GetProjectsRQ struct {
	ID        *int64
	Name      *string
	StartDate *string
	EndDate   *string
	Enabled   *bool
}

type UpdateProjectRQ struct {
	ID        int64
	Name      string
	StartDate string
	EndDate   string
	Enabled   bool
}
