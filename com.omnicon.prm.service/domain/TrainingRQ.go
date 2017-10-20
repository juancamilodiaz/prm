package domain

type TrainingRQ struct {
	ID             int
	Name           string
	ResourceId     int
	TypeId         int
	TrainingSkills []*TrainingSkills
}

type TrainingRS struct {
	Training       *Training
	Header         *Response_Header
	TrainingSkills []*TrainingSkills
	Resources      []*Resource
	Types          []*Type
	Status         string
	Message        string
}
