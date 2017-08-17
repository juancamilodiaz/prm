package domain

type CreateResourceRQ struct {
	Name     string
	LastName string
	Email    string
	Photo    string
	Level    Level
	Enable   bool
}
