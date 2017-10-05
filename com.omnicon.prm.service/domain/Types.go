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

type TypeSkillsRS struct {
	Header     *Response_Header
	TypeSkills []*TypeSkills
	Skills     []*Skill
	Status     string
	Message    string
}

type ProjectTypesRQ struct {
	ID        int
	ProjectId int
	TypeId    int
	Name      string
}

type TypeSkillsRQ struct {
	ID      int
	TypeId  int
	SkillId int
	Name    string
	Value   int
}

//--------- Get ProjectTypes
type ProjectTypesRS struct {
	Header       *Response_Header
	ProjectTypes []*ProjectTypes
	Types        []*Type
	Status       string
	Message      string
}
