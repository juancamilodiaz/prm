package domain

type CreateSkillRQ struct {
	Name string
}

type DeleteSkillRQ struct {
	ID int
}

type DeleteSkillToResourceRQ struct {
	ResourceId int
	SkillId    int
}

type GetSkillsRQ struct {
	ID   int
	Name string
}

type SetSkillToResourceRQ struct {
	ResourceId int
	SkillId    int
	Value      int
}

type UpdateSkillRQ struct {
	ID   int
	Name string
}

type GetTypesRQ struct {
	ID   int
	Name string
}
