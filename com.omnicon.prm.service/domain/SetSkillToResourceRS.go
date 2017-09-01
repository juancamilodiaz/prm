package domain

type SetSkillToResourceRS struct {
	Header   *SetSkillToResourceRS_Header
	Resource *Resource
	Status   string
	Message  string
}

type SetSkillToResourceRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *SetSkillToResourceRS) GetHeader() *SetSkillToResourceRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
