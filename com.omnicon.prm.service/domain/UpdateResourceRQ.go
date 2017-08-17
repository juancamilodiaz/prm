package domain

type UpdateResourceRQ struct {
	ID       string
	Name     string
	LastName string
	Email    string
	Photo    string
	Level    Level
	Enable   bool
}
