package domain

type ProjectForecastRQ struct {
	ID                   int
	Name                 string
	BusinessUnit         string
	Region               string
	Description          string
	StartDate            string
	EndDate              string
	Hours                float64
	NumberSites          int
	NumberProcessPerSite int
	NumberProcessTotal   int
	Types                []string
	TypeID               int
	TypeName             string
	TypeNumberResources  int
	EstimateCost         float64
	BillingDate          string
	Status               string
}

type ProjectForecastAssignsRQ struct {
	ID                  int
	ProjectForecastId   int
	ProjectForecastName string
	TypeId              int
	TypeName            string
	NumberResources     int
}

type DeleteProjectForecastAssignsRQ struct {
	IDs []int
}
