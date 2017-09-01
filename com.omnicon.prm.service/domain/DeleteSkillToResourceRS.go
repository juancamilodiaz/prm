package domain

type DeleteSkillToResourceRS struct {
	Header       *DeleteSkillToResourceRS_Header
	ID           int64
	SkillName    string
	ResourceName string
	Status       string
	Message      string
}

type DeleteSkillToResourceRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *DeleteSkillToResourceRS) GetHeader() *DeleteSkillToResourceRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
