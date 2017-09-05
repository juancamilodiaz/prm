package domain

type GetSkillsRS struct {
	Header  *GetSkillsRS_Header
	Skills  []*Skill
	Status  string
	Message string
}

type GetSkillsRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *GetSkillsRS) GetHeader() *GetSkillsRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
