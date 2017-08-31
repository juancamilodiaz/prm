package domain

type DeleteResourceRS struct {
	Header   *DeleteResourceRS_Header
	ID       int64
	Name     string
	LastName string
	Status   string
	Message  string
}

type DeleteResourceRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *DeleteResourceRS) GetHeader() *DeleteResourceRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
