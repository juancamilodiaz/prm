package domain

type UpdateProjectRS struct {
	Project *Project
	Status  bool
	Message string
}
