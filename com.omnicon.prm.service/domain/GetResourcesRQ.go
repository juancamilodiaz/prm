package domain

type GetResourcesRQ struct {
	ID            *int64
	Name          *string
	LastName      *string
	Email         *string
	EngineerRange *string
	Enabled       *bool
	Skills        map[string]int
}
