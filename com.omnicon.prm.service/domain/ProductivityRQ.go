package domain

type ProductivityTasksRQ struct {
	ID            int
	ProjectID     int
	Name          string
	TotalExecute  float64
	Scheduled     float64
	Progress      float64
	IsOutOfScope  bool
	TotalBillable float64
}

type ProductivityTasksRS struct {
	Header            *Response_Header
	Status            string
	Message           string
	ProductivityTasks []*ProductivityTasks
	ResourceReports   map[int]*ResourceReport
}

type ProductivityReportRQ struct {
	ID            int
	TaskID        int
	ResourceID    int
	Hours         float64
	HoursBillable float64
	IsBillable    bool
}

type ProductivityReportRS struct {
	Header             *Response_Header
	Status             string
	Message            string
	ProductivityReport []*ProductivityReport
}
