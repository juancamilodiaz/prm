package domain

//-------- Create Skill
type CreateSkillRS struct {
	Header  *CreateSkillRS_Header
	Skill   *Skill
	Status  string
	Message string
}

type CreateSkillRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *CreateSkillRS) GetHeader() *CreateSkillRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Delete Skill

type DeleteSkillRS struct {
	Header  *DeleteSkillRS_Header
	ID      int64
	Name    string
	Status  string
	Message string
}

type DeleteSkillRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *DeleteSkillRS) GetHeader() *DeleteSkillRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Delete Skill to Resource
type DeleteSkillToResourceRS struct {
	Header       *DeleteSkillToResourceRS_Header
	ID           int64
	SkillName    string
	ResourceName string
	Status       string
	Message      string
}

type DeleteSkillToResourceRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *DeleteSkillToResourceRS) GetHeader() *DeleteSkillToResourceRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Get Skill
type GetSkillsRS struct {
	Header  *GetSkillsRS_Header
	Skills  []*Skill
	Status  string
	Message string
}

type GetSkillsRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *GetSkillsRS) GetHeader() *GetSkillsRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Set Skills to Resource
type SetSkillToResourceRS struct {
	Header   *SetSkillToResourceRS_Header
	Resource *Resource
	Status   string
	Message  string
}

type SetSkillToResourceRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *SetSkillToResourceRS) GetHeader() *SetSkillToResourceRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}

//-------- Update Skill

type UpdateSkillRS struct {
	Header  *UpdateSkillRS_Header
	Skill   *Skill
	Status  string
	Message string
}

type UpdateSkillRS_Header struct {
	ResponseTime string
	RequestDate  string
}

func (m *UpdateSkillRS) GetHeader() *UpdateSkillRS_Header {
	if m != nil {
		return m.Header
	}
	return nil
}
