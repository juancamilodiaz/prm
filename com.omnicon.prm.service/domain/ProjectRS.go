package domain

//--------- Create Project
type CreateProjectRS struct {
	Header  *Response_Header
	Project *Project
	Status  string
	Message string
}

func (m *CreateProjectRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//--------- Delete Project

type DeleteProjectRS struct {
	Header  *Response_Header
	ID      int
	Name    string
	Status  string
	Message string
}

func (m *DeleteProjectRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//--------- Update Project
type UpdateProjectRS struct {
	Header  *Response_Header
	Project *Project
	Status  string
	Message string
}

func (m *UpdateProjectRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//--------- Get Project
type GetProjectsRS struct {
	Header      *Response_Header
	Projects    []*Project
	Status      string
	Message     string
	ProjectType string
}

func (m *GetProjectsRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
