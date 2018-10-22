package domain

type PlanningRS struct {
	Header   *Response_Header
	Status   string
	Message  string
	Planning []*Planning
}

func (m *PlanningRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

type UpdatePlanningRS struct {
	Header     *Response_Header
	PlanningId int
	Error      error
	Status     string
	Message    string
}

func (m *UpdatePlanningRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
