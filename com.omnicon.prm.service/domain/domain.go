package domain

import "time"

type Resource struct {
	ID            int64  `db:"id"`
	Name          string `db:"name"`
	LastName      string `db:"last_name"`
	Email         string `db:"email"`
	Photo         string `db:"photo"`
	EngineerRange string `db:"engineer_range"`
	Enabled       bool   `db:"enabled"`
	Skills        map[string]int
}

type Project struct {
	ID             int64     `db:"id"`
	Name           string    `db:"name"`
	StartDate      time.Time `db:"start_date"`
	EndDate        time.Time `db:"end_date"`
	Enabled        bool      `db:"enabled"`
	ResourceAssign map[int64]*ResourceAssign
	Lead           string
	ProjectType    []*Type
}

type Type struct {
	ID   int    `db:"id"`
	Name string `db:"value"`
}

type ProjectTypes struct {
	ID        int64  `db:"id"`
	ProjectId int64  `db:"project_id"`
	TypeId    int    `db:"type_id"`
	Name      string `db:"type_name"`
}

type ProjectResources struct {
	ID           int64     `db:"id"`
	ProjectId    int64     `db:"project_id"`
	ResourceId   int64     `db:"resource_id"`
	ProjectName  string    `db:"project_name"`
	ResourceName string    `db:"resource_name"`
	StartDate    time.Time `db:"start_date"`
	EndDate      time.Time `db:"end_date"`
	Lead         bool      `db:"lead"`
	Hours        float64   `db:"hours"`
}

type ResourceSkills struct {
	ID         int64  `db:"id"`
	ResourceId int64  `db:"resource_id"`
	SkillId    int64  `db:"skill_id"`
	Name       string `db:"name"`
	Value      int    `db:"value"`
}

type Skill struct {
	ID   int64  `db:"id"`
	Name string `db:"name"`
}

type TypeSkills struct {
	ID      int    `db:"id"`
	TypeId  int    `db:"type_id"`
	SkillId int    `db:"skill_id"`
	Name    string `db:"skill_name"`
	Value   int    `db:"value"`
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
