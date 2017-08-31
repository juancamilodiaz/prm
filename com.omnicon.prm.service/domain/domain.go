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
}

type Project struct {
	ID        int64     `db:"id"`
	Name      string    `db:"name"`
	StartDate time.Time `db:"start_date"`
	EndDate   time.Time `db:"end_date"`
	Enabled   bool      `db:"enabled"`
}

type ProjectUsers struct {
	ID            int64
	ProjectID     string
	ListResources []Resource
	ProjectLead   Resource
}

type ResourceSkills struct {
	ID         int64 `db:"id"`
	ResourceId int64 `db:"resource_id"`
	SkillId    int64 `db:"skill_id"`
	Value      int   `db:"value"`
}

type Skill struct {
	ID   int64  `db:"id"`
	Name string `db:"name"`
}
