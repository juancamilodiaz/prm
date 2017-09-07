package domain

//-------- Create Resource
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

//-------- Delete Resource
type DeleteResourceRS struct {
	Header   *DeleteResourceRS_Header
	ID       int64
	Name     string
	LastName string
	Status   string
	Message  string
}

type DeleteResourceRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *DeleteResourceRS) GetHeader() *DeleteResourceRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Get Resource
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

//-------- Set Resource to Project
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

//-------- Get Resources to Project
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

//-------- Delete Resource to Project
type DeleteResourceToProjectRS struct {
	Header       *DeleteResourceToProjectRS_Header
	ID           int64
	ResourceName string
	ProjectName  string
	Status       string
	Message      string
}

type DeleteResourceToProjectRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *DeleteResourceToProjectRS) GetHeader() *DeleteResourceToProjectRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Update Resource
type UpdateResourceRS struct {
	Header   *UpdateResourceRS_Header
	Resource *Resource
	Status   string
	Message  string
}

type UpdateResourceRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *UpdateResourceRS) GetHeader() *UpdateResourceRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
