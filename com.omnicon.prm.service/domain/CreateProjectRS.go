package domain

type CreateProjectRS struct {
	Header  *CreateProjectRS_Header
	Project *Project
	Status  string
	Message string
}

type CreateProjectRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *CreateProjectRS) GetHeader() *CreateProjectRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
