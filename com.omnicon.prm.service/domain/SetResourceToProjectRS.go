package domain

type SetResourceToProjectRS struct {
	Header  *SetResourceToProjectRS_Header
	Project *Project
	Status  string
	Message string
}

type SetResourceToProjectRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *SetResourceToProjectRS) GetHeader() *SetResourceToProjectRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
