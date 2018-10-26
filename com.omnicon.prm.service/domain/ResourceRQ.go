package domain

type CreateResourceRQ struct {
	Name          string
	LastName      string
	Email         string
	Photo         string
	EngineerRange string
	Enabled       bool
	VisaUS        string
}

type DeleteResourceRQ struct {
	ID int
}

type GetResourcesRQ struct {
	ID            int
	Name          string
	LastName      string
	Email         string
	EngineerRange string
	Enabled       *bool
	Skills        map[string]int
	ResourceType  []*Type
	TaskStartDate string
	TaskEndDate   string
}

type SetResourceToProjectRQ struct {
	ID            int
	ProjectId     int
	ResourceId    int
	StartDate     string
	EndDate       string
	Lead          bool // TODO Delete all relations
	Hours         float64
	IsToCreate    bool
	HoursPerDay   float64
	IsHoursPerDay bool
}

type GetResourcesToProjectsRQ struct {
	ID           int
	ProjectId    int
	ResourceId   int
	ProjectName  string
	ResourceName string
	StartDate    string
	EndDate      string
	Lead         *bool
	Hours        float64
	Enabled      bool
}

type DeleteResourceToProjectRQ struct {
	IDs []int
}

type UpdateResourceRQ struct {
	ID            int
	Name          string
	LastName      string
	Email         string
	Photo         string
	EngineerRange string
	Enabled       bool
	VisaUS        string
}

type GetSkillByResourceRQ struct {
	ID int
}
