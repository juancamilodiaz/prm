package domain

type GetProjectsRS struct {
	Header   *GetProjectsRS_Header
	Projects []*Project
	Status   string
	Message  string
}

type GetProjectsRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *GetProjectsRS) GetHeader() *GetProjectsRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
