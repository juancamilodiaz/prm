package domain

//--------- Create Project Forecast
type CreateProjectForecastRS struct {
	Header          *Response_Header
	ProjectForecast *ProjectForecast
	Status          string
	Message         string
}

func (m *CreateProjectForecastRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//--------- Delete Project Forecast

type DeleteProjectForecastRS struct {
	Header  *Response_Header
	ID      int
	Name    string
	Status  string
	Message string
}

func (m *DeleteProjectForecastRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//--------- Update Project Forecast
type UpdateProjectForecastRS struct {
	Header          *Response_Header
	ProjectForecast *ProjectForecast
	Status          string
	Message         string
}

func (m *UpdateProjectForecastRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//--------- Get Project Forecast
type GetProjectsForecastRS struct {
	Header          *Response_Header
	ProjectForecast []*ProjectForecast
	Status          string
	Message         string
	ProjectType     string
}

func (m *GetProjectsForecastRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Set ProjectForecast Assign
type SetProjectForecastAssignsRS struct {
	Header                 *Response_Header
	ProjectForecastAssigns *ProjectForecastAssigns
	Status                 string
	Message                string
}

func (m *SetProjectForecastAssignsRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Get ProjectForecast Assign
type GetProjectForecastAssignsRS struct {
	Header                 *Response_Header
	ProjectForecastAssigns []*ProjectForecastAssigns
	Status                 string
	Message                string
}

func (m *GetProjectForecastAssignsRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Delete ProjectForecastAssign
type DeleteProjectForecastAssignsRS struct {
	Header          *Response_Header
	IDs             []int
	NumberResources int
	ProjectName     string
	Status          string
	Message         string
}

func (m *DeleteProjectForecastAssignsRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
