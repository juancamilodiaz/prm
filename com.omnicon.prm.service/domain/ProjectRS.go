package domain

//--------- Create Project
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

//--------- Delete Project

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

//--------- Update Project
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

//--------- Get Project
type GetProjectsRS struct {
	Header      *GetProjectsRS_Header
	Projects    []*Project
	Status      string
	Message     string
	ProjectType string
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
