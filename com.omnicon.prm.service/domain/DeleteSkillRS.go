package domain

type DeleteSkillRS struct {
	Header  *DeleteSkillRS_Header
	ID      int64
	Name    string
	Status  string
	Message string
}

type DeleteSkillRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *DeleteSkillRS) GetHeader() *DeleteSkillRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
