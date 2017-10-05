package domain

type CreateSkillRQ struct {
	Name string
}

type DeleteSkillRQ struct {
	ID int64
}

type DeleteSkillToResourceRQ struct {
	ResourceId int64
	SkillId    int64
}

type GetSkillsRQ struct {
	ID   int64
	Name string
}

type SetSkillToResourceRQ struct {
	ResourceId int64
	SkillId    int64
	Value      int
}

type UpdateSkillRQ struct {
	ID   int64
	Name string
}

type GetTypesRQ struct {
	ID   int64
	Name string
}
