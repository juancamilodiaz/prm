package domain

type UpdateProjectRS struct {
	Header  *UpdateProjectRS_Header
	Project *Project
	Status  string
	Message string
}

type UpdateProjectRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *UpdateProjectRS) GetHeader() *UpdateProjectRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
