package domain

type UpdateResourceRS struct {
	Resource *Resource
	Status   bool
	Message  string
}
