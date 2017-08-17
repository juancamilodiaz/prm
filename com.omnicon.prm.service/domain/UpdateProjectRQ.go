package domain

type UpdateProjectRQ struct {
	ID        string
	Name      string
	StartDate int64
	EndDate   int64
	Enable    bool
}
