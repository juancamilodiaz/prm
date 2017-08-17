package domain

type Resource struct {
	ID       string
	Name     string
	LastName string
	Email    string
	Photo    string
	Level    Level
	Enable   bool
}

type Project struct {
	ID        string
	Name      string
	StartDate int64
	EndDate   int64
	Enable    bool
}

type ProjectUsers struct {
	ID            int64
	ProjectID     string
	ListResources []Resource
	ProjectLead   Resource
}

type Level struct {
}
