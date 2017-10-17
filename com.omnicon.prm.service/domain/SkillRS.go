package domain

//-------- Create Skill
type CreateSkillRS struct {
	Header  *Response_Header
	Skill   *Skill
	Status  string
	Message string
}

func (m *CreateSkillRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Create Skill
type GetSkillByResourceRS struct {
	Header  *Response_Header
	Skills  []*ResourceSkills
	Status  string
	Message string
}

func (m *GetSkillByResourceRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Delete Skill

type DeleteSkillRS struct {
	Header  *Response_Header
	ID      int
	Name    string
	Status  string
	Message string
}

func (m *DeleteSkillRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Delete Skill to Resource
type DeleteSkillToResourceRS struct {
	Header       *Response_Header
	ID           int
	SkillName    string
	ResourceName string
	Status       string
	Message      string
}

func (m *DeleteSkillToResourceRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Get Skill
type GetSkillsRS struct {
	Header  *Response_Header
	Skills  []*Skill
	Status  string
	Message string
}

func (m *GetSkillsRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Set Skills to Resource
type SetSkillToResourceRS struct {
	Header   *Response_Header
	Resource *Resource
	Status   string
	Message  string
}

func (m *SetSkillToResourceRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Update Skill

type UpdateSkillRS struct {
	Header  *Response_Header
	Skill   *Skill
	Status  string
	Message string
}

func (m *UpdateSkillRS) GetHeader() *Response_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
