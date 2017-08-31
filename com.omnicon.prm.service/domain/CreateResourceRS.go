package domain

type CreateResourceRS struct {
	Header   *CreateResourceRS_Header
	Resource *Resource
	Status   string
	Message  string
}

type CreateResourceRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *CreateResourceRS) GetHeader() *CreateResourceRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
