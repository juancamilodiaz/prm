package domain

type GetResourcesRQ struct {
	Name          *string
	LastName      *string
	Email         *string
	EngineerRange *string
	Enabled       *bool
	Skills        map[string]int
}
