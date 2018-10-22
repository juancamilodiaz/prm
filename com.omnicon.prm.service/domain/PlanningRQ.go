package domain

type PlanningRQ struct {
	Id    int
	Field string
	Value string
}

type GetPlanningRQ struct {
	Week int
}
