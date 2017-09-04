package domain

type GetProjectsRQ struct {
	Name      *string
	StartDate *string
	EndDate   *string
	Enabled   *bool
}
