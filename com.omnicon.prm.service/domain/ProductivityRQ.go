package domain

type ProductivityTasksRQ struct {
	ID           int
	ProjectID    int
	Name         string
	TotalExecute float64
	Scheduled    float64
	Progress     float64
}

type ProductivityTasksRS struct {
	Header            *Response_Header
	Status            string
	Message           string
	ProductivityTasks []*ProductivityTasks
}

type ProductivityReportRQ struct {
	ID         int
	TaskID     int
	ResourceID int
	Hours      float64
}

type ProductivityReportRS struct {
	Header             *Response_Header
	Status             string
	Message            string
	ProductivityReport []*ProductivityReport
}
