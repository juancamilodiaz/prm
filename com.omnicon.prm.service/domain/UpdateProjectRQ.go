package domain

type UpdateProjectRQ struct {
	ID        int64
	Name      string
	StartDate string
	EndDate   string
	Enable    bool
}
