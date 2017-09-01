package domain

type DeleteProjectRS struct {
	Header  *DeleteProjectRS_Header
	ID      int64
	Name    string
	Status  string
	Message string
}

type DeleteProjectRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *DeleteProjectRS) GetHeader() *DeleteProjectRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
