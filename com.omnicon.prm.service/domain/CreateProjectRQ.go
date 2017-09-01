package domain

type CreateProjectRQ struct {
	Name      string
	StartDate string
	EndDate   string
	Enabled   bool
}
