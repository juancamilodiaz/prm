package domain

//-------- Type Object
type TypeRS struct {
	Header  *Response_Header
	Types   []*Type
	Status  string
	Message string
}

//--------
type TypeRQ struct {
	ID   int
	Name string
}

type Response_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *TypeRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
