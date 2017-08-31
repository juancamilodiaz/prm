package domain

type CreateProjectRQ struct {
	Name      string
	StartDate string
	EndDate   string
	Enable    bool
}
