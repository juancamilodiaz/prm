package domain

import "time"

type Resource struct {
	ID            int    `db:"id"`
	Name          string `db:"name"`
	LastName      string `db:"last_name"`
	Email         string `db:"email"`
	Photo         string `db:"photo"`
	EngineerRange string `db:"engineer_range"`
	Enabled       bool   `db:"enabled"`
	Skills        map[string]int
}

type Project struct {
	ID              int       `db:"id"`
	Name            string    `db:"name"`
	StartDate       time.Time `db:"start_date"`
	EndDate         time.Time `db:"end_date"`
	Enabled         bool      `db:"enabled"`
	ResourceAssign  map[int]*ResourceAssign
	Percent         int
	Lead            string
	ProjectType     []*Type
	OperationCenter string `db:"operation_center"`
	WorkOrder       int    `db:"work_order"`
}

type Type struct {
	ID   int    `db:"id"`
	Name string `db:"name"`
}

type ProjectTypes struct {
	ID        int    `db:"id"`
	ProjectId int    `db:"project_id"`
	TypeId    int    `db:"type_id"`
	Name      string `db:"type_name"`
}

type ProjectResources struct {
	ID           int       `db:"id"`
	ProjectId    int       `db:"project_id"`
	ResourceId   int       `db:"resource_id"`
	ProjectName  string    `db:"project_name"`
	ResourceName string    `db:"resource_name"`
	StartDate    time.Time `db:"start_date"`
	EndDate      time.Time `db:"end_date"`
	Lead         bool      `db:"lead"`
	Hours        float64   `db:"hours"`
}

type ResourceSkills struct {
	ID         int    `db:"id"`
	ResourceId int    `db:"resource_id"`
	SkillId    int    `db:"skill_id"`
	Name       string `db:"name"`
	Value      int    `db:"value"`
}

type Skill struct {
	ID   int    `db:"id"`
	Name string `db:"name"`
}

type TypeSkills struct {
	ID      int    `db:"id"`
	TypeId  int    `db:"type_id"`
	SkillId int    `db:"skill_id"`
	Name    string `db:"skill_name"`
	Value   int    `db:"value"`
}

type Training struct {
	ID        int    `db:"id"`
	TypeId    int    `db:"type_id"`
	SkillId   int    `db:"skill_id"`
	Name      string `db:"name"`
	TypeName  string
	SkillName string
}
type TrainingResources struct {
	ID           int       `db:"id"`
	TrainingId   int       `db:"training_id"`
	ResourceId   int       `db:"resource_id"`
	StartDate    time.Time `db:"start_date"`
	EndDate      time.Time `db:"end_date"`
	Duration     int       `db:"duration"`
	Progress     int       `db:"progress"`
	TestResult   int       `db:"test_result"`
	ResultStatus string    `db:"result_status"`
}

type ResourceAssign struct {
	Resource  *Resource
	StartDate time.Time
	EndDate   time.Time
	Lead      bool
	Hours     float64
}

type RangeDatesAvailability struct {
	StartDate string
	EndDate   string
	Hours     float64
}

type ResourceAvailabilityInformation struct {
	ListOfRange []*RangeDatesAvailability
	TotalHours  float64
}

type ListByHours struct {
	ResourceId    int
	Days          int
	NumberOfRange int
}
