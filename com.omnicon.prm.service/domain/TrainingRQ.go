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
	Status         string
	Message        string
}
