package util

import (
	"errors"
	"time"

	"prm/com.omnicon.prm.service/log"
)

// Formato YYYY-MM-DD
const DATEFORMAT = "2006-01-02"

// Formato DD/MM/YYYY
const DATEFORMAT2 = "02/01/2006"

// Formato YYYY-MM-DD hh:mm:ss
const DATEFORMATHOUR = "2006-01-02 15:04:05"

// Formato YYYY-MM-DD hh:mm
const DATEFORMATHOURWITHOUTSEC = "2006-01-02 15:04"

// Formato YYYY-MM-DD hh:mm:ss zzz UTC
const LONGFORMAT = "2006-01-02 15:04:05.999999999 -0700 MST"
const LONGFORMATALT = "2006-01-02 15:04:05.999999999 -0700 -07"

// Formato YYYY-MM-DD hh:mm:ss zzz
const SHORTFORMAT = "2006-01-02 15:04:05.999999999"

// Formato HH:mm
const HOURFORMAT = "15:04"

func ConvertirFechasPeticion(pEntrada, pSalida *string) (int64, int64, error) {

	var entradaUnix, salidaUnix int64

	if pEntrada == nil || pSalida == nil {
		return entradaUnix, salidaUnix, errors.New("Error Falta alguna fecha")
	}

	entradaTime, err := time.Parse(DATEFORMAT, *pEntrada) //'YYYY-MM-DD'
	if err != nil {
		log.Errorf("[ConvertirFechasPeticion] Fecha de Entrada %v debe estar en el formato YYYY-MM-DD \n", pEntrada)
		return entradaUnix, salidaUnix, errors.New("Error en formato de fecha entrada")
	}
	salidaTime, err := time.Parse(DATEFORMAT, *pSalida) //'YYYY-MM-DD'
	if err != nil {
		log.Errorf("[ConvertirFechasPeticion] Fecha de Salida %v debe estar en el formato YYYY-MM-DD \n", pSalida)
		return entradaUnix, salidaUnix, errors.New("Error en formato de fecha entrada")
	}

	log.Debug("[ConvertirFechasPeticion] entrada", entradaTime.Format(DATEFORMAT))
	log.Debug("[ConvertirFechasPeticion] salida", salidaTime.Format(DATEFORMAT))

	entradaUnix = entradaTime.Unix()
	salidaUnix = salidaTime.Unix()

	return entradaUnix, salidaUnix, nil
}

func ParseDate(pEntrada *string) (int64, error) {

	var entradaUnix int64

	if pEntrada == nil {
		return entradaUnix, errors.New("Error Falta la fecha")
	}

	entradaTime, err := time.Parse(DATEFORMAT, *pEntrada) //'YYYY-MM-DD'
	if err != nil {
		log.Errorf("[ParseDate] Fecha de Entrada %v debe estar en el formato YYYY-MM-DD \n", pEntrada)
		return entradaUnix, errors.New("Error en formato de fecha entrada")
	}

	log.Debug("[ParseDate] entrada", entradaTime.Format(DATEFORMAT))

	entradaUnix = entradaTime.Unix()

	return entradaUnix, nil
}

// Convierte una fecha string a int64
func GetDateInt64FromString(pFecha string) int64 {
	fechaTime, err := time.Parse(DATEFORMAT, pFecha) //"2006-01-02"
	if err != nil {
		log.Errorf("Fecha %v debe estar en el formato YYYY-MM-DD \n", pFecha)
		return 0
	}
	return fechaTime.Unix()
}

// Convierte una fecha con hora string a int64
func GetDateInt64FromStringHour(pFecha string) int64 {
	fechaTime, err := time.Parse(DATEFORMATHOUR, pFecha) //"2006-01-02"
	if err != nil {
		log.Errorf("Fecha %v debe estar en el formato YYYY-MM-DD hh:mm:ss \n", pFecha)
		return 0
	}
	return fechaTime.Unix()
}

// Convierte una fecha con hora sin segundos string a int64
func getHourInt64FromStringAndFormat(pFecha, pFormato string) int64 {
	fechaTime, err := time.Parse(pFormato, pFecha) //"HH:MM"
	if err != nil {
		log.Errorf("Fecha %v debe estar en el formato hh:mm \n", pFecha)
		return 0
	}
	return fechaTime.Unix()
}

// Convierte una fecha reserva string a int64
func GetDateInt64FromFechaReserva(pFecha string) int64 {
	fechaTime, err := time.Parse(LONGFORMAT, pFecha) //'YYYY-MM-DD'
	if err != nil {
		fechaTime, err = time.Parse(LONGFORMATALT, pFecha)
		if err != nil {
			log.Errorf("Fecha %v no tiene algun formato valido %v %v \n", pFecha, LONGFORMAT, LONGFORMATALT)
			return 0
		}
	}
	return fechaTime.Unix()
}

func GetDateTimeFromFechaReserva(pFechaReserva string) time.Time {
	fechaReserva, err := time.Parse(LONGFORMAT, pFechaReserva)
	if err != nil {
		fechaReserva, err = time.Parse(LONGFORMATALT, pFechaReserva)
		if err != nil {
			log.Error("[GetDateTimeFromFechaReserva] Ocurrio un error al convertir la fecha", pFechaReserva)
		}
	}
	return fechaReserva
}

// Convierte una fecha local string a int64
func GetDateInt64FromFechaLocal(pFecha string) int64 {
	fechaTime, err := time.Parse(SHORTFORMAT, pFecha) //"2006-01-02 15:04:05.999999999"
	if err != nil {
		log.Errorf("Fecha %v debe estar en el formato YYYY-MM-DD \n", pFecha)
		return 0
	}
	return fechaTime.Unix()
}

// Agrega o resta dias a una fecha
func AgregarORestaDiasAUnaFecha(pFecha int64, pDias int) int64 {
	fecha := time.Unix(pFecha, 0)
	dias := time.Duration(24 * pDias)
	fecha = fecha.Add(dias * time.Hour)
	return fecha.Unix()
}

// Calcula la cantidad de dias que hay entre la pFechaInicial y pFechaFinal
func CalcularDiasEntreDosFechas(pFechaInicial, pFechaFinal int64) int {
	difDays := time.Unix(pFechaFinal, 0).Sub(time.Unix(pFechaInicial, 0))
	numDiasPeticion := int(difDays.Hours() / 24)
	return numDiasPeticion
}

// Obtiene una fecha en string con el pFormato dado.
func GetFechaConFormato(pFecha int64, pFormato string) string {
	fecha := time.Unix(pFecha, 0)
	return fecha.Format(pFormato)
}

// Obtiene una fecha en string con el pFormato dado y la retorna en int64.
func GetFechaInt64ConFormato(pFecha int64, pFormato string) int64 {
	fecha := time.Unix(pFecha, 0)
	return GetDateInt64FromString(fecha.Format(pFormato))
}

// Obtiene una fecha con hora sin segundos en string con el pFormato dado y la retorna en int64.
func GetHoraInt64ConFormato(pHora int64) int64 {
	hora := time.Unix(pHora, 0)
	horaOrigen := time.Date(1970, 01, 01, hora.Hour(), hora.Minute(), 0, 0, hora.Location())
	return horaOrigen.Unix()
}

// Obtiene un slice con el timestamp de los dias del rango, no se incluye el ultimo dia
func GetRangeDays(pFechaInicial, pFechaFinal int64) []int64 {
	noches := CalcularDiasEntreDosFechas(pFechaInicial, pFechaFinal)
	diasPeticion := []int64{}
	for posDia := 0; posDia < noches; posDia++ {
		dia := AgregarORestaDiasAUnaFecha(pFechaInicial, posDia)
		diasPeticion = append(diasPeticion, dia)
	}
	return diasPeticion
}

// Agrega o resta horas a una fecha
func AgregarORestaHorasAUnaFecha(pFecha int64, pHoras int) int64 {
	fecha := time.Unix(pFecha, 0)
	horas := time.Duration(pHoras)
	fecha = fecha.Add(horas * time.Hour)
	return fecha.Unix()
}

// Devuelve una fecha sin tiempo, en formato int64
func GetDateLocalWithoutTime(pFecha string) int64 {
	fechaTime, err := time.Parse(SHORTFORMAT, pFecha)
	if err != nil {
		log.Error("El formato de la fecha no es el adecuado", pFecha)
	}
	fehcaWithoutTime := fechaTime.Format(DATEFORMAT)
	fechaTimeWithoutTime, err := time.Parse(DATEFORMAT, fehcaWithoutTime)
	if err != nil {
		log.Error("El formato de la fecha no es el adecuado", fehcaWithoutTime)
	}
	return fechaTimeWithoutTime.Unix()
}

/*
   Nos revuelve un range entre dos fechas. Es útil para utilizar luego en un
   bucle.

   Nótese que para sacar el rango en orden inverso basta con que la fecha
   inicial sea mayor que la final, entonces se contarán los días hacia atrás.

   Si pasamos el solo_noches a True, se contará un dia menos.  Para contar sólo
   las noches entre el rango.
*/
func DateRange(pFechaInicial, pFechaFinal int64, pSoloNoches bool) []int64 {
	var avance, incremento int
	if pFechaInicial > pFechaFinal {
		incremento = -1
		if pSoloNoches {
			incremento = 0
		}
		avance = -1
	} else {
		incremento = 1
		if pSoloNoches {
			incremento = 0
		}
		avance = 1
	}

	rangoFechas := []int64{}
	if avance == 1 {
		cantidadDias := CalcularDiasEntreDosFechas(pFechaInicial, pFechaFinal) + incremento
		for dia := 0; dia < cantidadDias; dia++ {
			rangoFechas = append(rangoFechas, AgregarORestaDiasAUnaFecha(pFechaInicial, dia))
		}
	} else if avance == -1 {
		cantidadDias := CalcularDiasEntreDosFechas(pFechaFinal, pFechaInicial) - incremento
		for dia := 0; dia < cantidadDias; dia++ {
			rangoFechas = append(rangoFechas, AgregarORestaDiasAUnaFecha(pFechaInicial, -dia))
		}
	}

	return rangoFechas
}

// Valida si una fecha se encuentra entre un rango de fechas
func Between(pFecha, pFechaInicio, pFechaFin int64) bool {
	if pFecha >= pFechaInicio && pFecha <= pFechaFin {
		return true
	}
	return false
}
