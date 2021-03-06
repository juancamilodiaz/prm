package domain

import (
	"database/sql"
	"time"
)

type Resource struct {
	ID            int     `db:"id"`
	Name          string  `db:"name"`
	LastName      string  `db:"last_name"`
	Email         string  `db:"email"`
	Photo         string  `db:"photo"`
	EngineerRange string  `db:"engineer_range"`
	Enabled       bool    `db:"enabled"`
	VisaUS        *string `db:"visa_us"`
	TaskStartDate string
	TaskEndDate   string
	Skills        map[string]int
	ResourceType  []*ResourceTypesCustom
	TaskDetail    []*TaskDetail
	Type          []*Type
}

type ResourceQuery struct {
	ID                 int           `db:"id"`
	Name               string        `db:"name"`
	LastName           string        `db:"last_name"`
	Email              string        `db:"email"`
	Photo              string        `db:"photo"`
	EngineerRange      string        `db:"engineer_range"`
	Enabled            bool          `db:"enabled"`
	VisaUS             *string       `db:"visa_us"`
	ResourceId         int           `db:"resource_id"`
	TypeId             int           `db:"type_id"`
	NameTypeR          string        `db:"type_name"`
	Task               string        `db:"task"`
	HoursTask          float64       `db:"hours"`
	ProjectName        string        `db:"project_name"`
	StartDate          time.Time     `db:"start_date"`
	EndDate            time.Time     `db:"end_date"`
	AssignatedBy       sql.NullInt64 `db:"assignated_by"`
	Deliverable        string        `db:"deliverable"`
	Requirements       string        `db:"requirements"`
	Priority           string        `db:"priority"`
	AdditionalComments string        `db:"additional_comments"`
	Skills             map[string]int

	ResourceType []*ResourceTypesCustom
	Type         []*Type
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
	OperationCenter string   `db:"operation_center"`
	WorkOrder       int      `db:"work_order"`
	LeaderID        *int     `db:"leader_id,omitempty"`
	Cost            *float64 `db:"cost,omitempty"`
}

type Type struct {
	ID      int    `db:"id"`
	Name    string `db:"name"`
	ApplyTo string `db:"apply_to"`
}

type ProjectTypes struct {
	ID        int    `db:"id"`
	ProjectId int    `db:"project_id"`
	TypeId    int    `db:"type_id"`
	Name      string `db:"type_name"`
}

type ProjectResources struct {
	ID                   int           `db:"id"`
	ProjectId            int           `db:"project_id"`
	ResourceId           int           `db:"resource_id"`
	ProjectName          string        `db:"project_name"`
	ResourceName         string        `db:"resource_name"`
	StartDate            time.Time     `db:"start_date"`
	EndDate              time.Time     `db:"end_date"`
	Lead                 bool          `db:"lead"`
	Hours                float64       `db:"hours"`
	Task                 string        `db:"task"`
	AssignatedBy         sql.NullInt64 `db:"assignated_by"`
	Deliverable          string        `db:"deliverable"`
	Requirements         string        `db:"requirements"`
	Priority             string        `db:"priority"`
	AdditionalComments   string        `db:"additional_comments"`
	AssignatedByName     string        `db:"name"`
	AssignatedByLastName string        `db:"last_name"`
	TaskDetail           []*TaskDetail
}

type TaskDetail struct {
	ProjectName          string        `db:"project_name"`
	StartDate            time.Time     `db:"start_date"`
	EndDate              time.Time     `db:"end_date"`
	Hours                float64       `db:"hours"`
	Task                 string        `db:"task"`
	AssignatedBy         sql.NullInt64 `db:"assignated_by"`
	Deliverable          string        `db:"deliverable"`
	Requirements         string        `db:"requirements"`
	Priority             string        `db:"priority"`
	AdditionalComments   string        `db:"additional_comments"`
	AssignatedByName     string        `db:"name"`
	AssignatedByLastName string        `db:"last_name"`
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
	TrainingName string
	ResourceName string
}

type TrainingBreakdown struct {
	SkillName         string
	TypeName          string
	StartDate         time.Time
	EndDate           time.Time
	Duration          int
	Progress          int
	TestResult        int
	ResultStatus      []ResultStatus
	TrainingResources []*TrainingResources
}

type ResultStatus struct {
	Key   string
	Value int
}

type ResourceAssign struct {
	Resource  *Resource
	StartDate time.Time
	EndDate   time.Time
	Lead      bool
	Hours     float64
}

type RangeDatesAvailability struct {
	StartDate    string
	EndDate      string
	Hours        float64
	HoursPerDay  float64
	ResourceName string
	ProjectName  string
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

type ResourceTypes struct {
	ID         int    `db:"id"`
	ResourceId int    `db:"resource_id"`
	TypeId     int    `db:"type_id"`
	Name       string `db:"type_name"`
}

type ResourceTypesCustom struct {
	ResourceId int    `db:"resource_id"`
	TypeId     int    `db:"type_id"`
	Name       string `db:"type_name"`
}

type ProjectForecast struct {
	ID                   int       `db:"id"`
	Name                 string    `db:"name"`
	BusinessUnit         string    `db:"business_unit"`
	Region               string    `db:"region"`
	Description          string    `db:"description,omitempty"`
	StartDate            time.Time `db:"start_date"`
	EndDate              time.Time `db:"end_date"`
	Hours                float64   `db:"hours"`
	NumberSites          int       `db:"number_sites"`
	NumberProcessPerSite int       `db:"number_process_per_site"`
	NumberProcessTotal   int       `db:"number_process_total"`
	Types                []string
	ProjectType          string
	AssignResources      map[int]ProjectForecastAssignResources
	TotalEngineers       int
	EstimateCost         float64   `db:"estimate_cost"`
	BillingDate          time.Time `db:"billing_date"`
	Status               string    `db:"status"`
}

type ProjectForecastAssignResources struct {
	TypeID          int
	Name            string
	NumberResources int
}

type ProjectForecastAssigns struct {
	ID                  int    `db:"id"`
	ProjectForecastId   int    `db:"projectForecast_id"`
	ProjectForecastName string `db:"projectForecast_name"`
	TypeId              int    `db:"type_id"`
	TypeName            string `db:"type_name"`
	NumberResources     int    `db:"number_resources"`
}

type ProjectForecastTypes struct {
	ID                int `db:"id"`
	ProjectForecastId int `db:"projectForecast_id"`
	TypeId            int `db:"type_id"`
}

type ProjectForecastWorkload struct {
	MonthNumber  int
	MOM          int
	DEV          int
	ResourceLoad float64
}

type Settings struct {
	ID          int    `db:"id"`
	Name        string `db:"name"`
	Value       string `db:"value"`
	Type        string `db:"type"`
	Description string `db:"description"`
}

type ProductivityTasks struct {
	ID            int     `db:"id"`
	ProjectID     int     `db:"project_id"`
	Name          string  `db:"name"`
	TotalExecute  float64 `db:"total_execute"`
	Scheduled     float64 `db:"scheduled"`
	Progress      float64 `db:"progress"`
	IsOutOfScope  bool    `db:"is_out_of_scope"`
	TotalBillable float64 `db:"total_billable"`
}

type ProductivityReport struct {
	ID            int     `db:"id"`
	TaskID        int     `db:"task_id"`
	ResourceID    int     `db:"resource_id"`
	Hours         float64 `db:"hours"`
	HoursBillable float64 `db:"hours_billable"`
}

type ResourceReport struct {
	ResourceID   int
	NameResource string
	ReportByTask map[int]*Report // Map[taskID]
}

type Report struct {
	ID            int // ID report
	Hours         float64
	HoursBillable float64
}

type ForecastByMonth struct {
	Weeks map[int]map[int]*UsageByWeek
}

type UsageByWeek struct {
	Month time.Month
	DEV   int
	MOM   int
}
