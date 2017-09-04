package domain

type GetResourcesRS struct {
	Header    *GetResourcesRS_Header
	Resources []*Resource
	Status    string
	Message   string
}

type GetResourcesRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *GetResourcesRS) GetHeader() *GetResourcesRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
