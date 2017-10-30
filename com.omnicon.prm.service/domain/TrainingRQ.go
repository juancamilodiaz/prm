package domain

type TrainingRQ struct {
	ID                int
	Name              string
	SkillId           int
	TypeId            int
	TrainingResources []*TrainingResources
}

type TrainingRS struct {
	Trainings   []*Training
	Header      *Response_Header
	Types       []*Type
	TypesSkills []*TypeSkills
	Skills      []*Skill
	Status      string
	Message     string
}

type TrainingResourcesRQ struct {
	ID           int
	TrainingId   int
	ResourceId   int
	StartDate    string
	EndDate      string
	Duration     int
	Progress     int
	TestResult   int
	ResultStatus string

	TypeID int
}

type TrainingResourcesRS struct {
	Header            *Response_Header
	Status            string
	Message           string
	FilteredTrainings []*Training
	TrainingResources map[int]*TrainingBreakdown
	Trainings         []*Training
	Resources         []*Resource
	Types             []*Type
	TypesSkills       []*TypeSkills
}
