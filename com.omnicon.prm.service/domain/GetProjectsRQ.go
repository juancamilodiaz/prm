package domain

type GetProjectsRQ struct {
	ID        *int64
	Name      *string
	StartDate *string
	EndDate   *string
	Enabled   *bool
}
