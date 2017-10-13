package domain

//-------- Create Resource
type CreateResourceRS struct {
	Header   *Response_Header
	Resource *Resource
	Status   string
	Message  string
}

func (m *CreateResourceRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Delete Resource
type DeleteResourceRS struct {
	Header   *Response_Header
	ID       int
	Name     string
	LastName string
	Status   string
	Message  string
}

func (m *DeleteResourceRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Get Resource
type GetResourcesRS struct {
	Header    *Response_Header
	Resources []*Resource
	Status    string
	Message   string
}

func (m *GetResourcesRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Set Resource to Project
type SetResourceToProjectRS struct {
	Header  *Response_Header
	Project *Project
	Status  string
	Message string
}

func (m *SetResourceToProjectRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Get Resources to Project
type GetResourcesToProjectsRS struct {
	Header                 *Response_Header
	ResourcesToProjects    []*ProjectResources
	Projects               []*Project
	Resources              []*Resource
	AvailBreakdown         map[int]map[string]float64
	AvailBreakdownPerRange map[int]*ResourceAvailabilityInformation
	Status                 string
	Message                string
}

func (m *GetResourcesToProjectsRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Delete Resource to Project
type DeleteResourceToProjectRS struct {
	Header       *Response_Header
	ID           int
	ResourceName string
	ProjectName  string
	Status       string
	Message      string
}

func (m *DeleteResourceToProjectRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Update Resource
type UpdateResourceRS struct {
	Header   *Response_Header
	Resource *Resource
	Status   string
	Message  string
}

func (m *UpdateResourceRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
