package domain

type GetResourcesToProjectsRS struct {
	Header              *GetResourcesToProjectsRS_Header
	ResourcesToProjects []*ProjectResources
	Status              string
	Message             string
}

type GetResourcesToProjectsRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *GetResourcesToProjectsRS) GetHeader() *GetResourcesToProjectsRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
