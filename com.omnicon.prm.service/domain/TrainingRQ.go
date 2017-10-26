package domain

type TrainingRQ struct {
	ID                int
	Name              string
	SkillId           int
	TypeId            int
	TrainingResources []*TrainingResources
}

type TrainingRS struct {
	Training          *Training
	Trainings         []*Training
	Header            *Response_Header
	TrainingResources []*TrainingResources
	Resources         []*Resource
	Types             []*Type
	TypesSkills       []*TypeSkills
	Skills            []*Skill
	Status            string
	Message           string
}
