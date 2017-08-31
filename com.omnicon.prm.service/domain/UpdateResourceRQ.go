package domain

type UpdateResourceRQ struct {
	ID            int64
	Name          string
	LastName      string
	Email         string
	Photo         string
	EngineerRange string
	Enabled       bool
}
