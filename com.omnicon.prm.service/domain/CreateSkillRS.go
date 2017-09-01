package domain

type CreateSkillRS struct {
	Header  *CreateSkillRS_Header
	Skill   *Skill
	Status  string
	Message string
}

type CreateSkillRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *CreateSkillRS) GetHeader() *CreateSkillRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
