package domain

type UpdateSkillRS struct {
	Header  *UpdateSkillRS_Header
	Skill   *Skill
	Status  string
	Message string
}

type UpdateSkillRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *UpdateSkillRS) GetHeader() *UpdateSkillRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
