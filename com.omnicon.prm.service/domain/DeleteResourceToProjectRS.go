package domain

type DeleteResourceToProjectRS struct {
	Header       *DeleteResourceToProjectRS_Header
	ID           int64
	ResourceName string
	ProjectName  string
	Status       string
	Message      string
}

type DeleteResourceToProjectRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *DeleteResourceToProjectRS) GetHeader() *DeleteResourceToProjectRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
