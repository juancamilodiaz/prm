package domain

type CreateResourceRS struct {
	Cabecera *CreateResourceRS_Cabecera
	Resource *Resource
	Status   bool
	Message  string
}

type CreateResourceRS_Cabecera struct {
	TiempoRespuesta string
	FechaPeticion   string
}

func (m *CreateResourceRS) GetCabecera() *CreateResourceRS_Cabecera {
	if m != nil {
		return m.Cabecera
	}
	return nil
}
