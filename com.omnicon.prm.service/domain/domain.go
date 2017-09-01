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
	Lead           Resource
}

type ProjectResources struct {
	ID         int64     `db:"id"`
	ProjectId  int64     `db:"project_id"`
	ResourceId int64     `db:"resource_id"`
	StartDate  time.Time `db:"start_date"`
	EndDate    time.Time `db:"end_date"`
	Lead       bool      `db:"lead"`
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

type ResourceAssign struct {
	Resource  *Resource
	StartDate time.Time
	EndDate   time.Time
	Lead      bool
}
