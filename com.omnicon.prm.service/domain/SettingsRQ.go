package domain

type SettingsRQ struct {
	ID    int
	Name  string
	Value string
	Type  string
}

type SettingsRS struct {
	Header   *Response_Header
	Status   string
	Message  string
	Settings []*Settings
}
