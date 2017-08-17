package domain

type CreateProjectRQ struct {
	Name      string
	StartDate int64
	EndDate   int64
	Enable    bool
}
