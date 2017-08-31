package domain

type UpdateResourceRS struct {
	Header   *UpdateResourceRS_Header
	Resource *Resource
	Status   string
	Message  string
}

type UpdateResourceRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *UpdateResourceRS) GetHeader() *UpdateResourceRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
