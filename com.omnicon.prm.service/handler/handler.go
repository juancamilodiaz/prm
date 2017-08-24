package handler

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	_ "time"

	"prm/com.omnicon.prm.service/controller"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/panics"
	"prm/com.omnicon.prm.service/util"
)

/*
Descripcion :
	Este metodo tiene como objetivo definir todos los mapeos entres URL y manegadores.
*/
func SetUpHandlers() {
	//se define el mapping entre las URL y los metodos
	http.HandleFunc("/CreateResource", createResource)
	//http.HandleFunc("/UpdateResource", updateResource)
}

/*
Descripcion : Funcion encargada de crear un recurso de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func createResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	//StartTime := time.Now()

	defer panics.CatchPanic("CreateResource")

	// Commented only testing
	/*f, errprof := os.Create("cpuprofile.pprof")
	if errprof != nil {
		log.Error(errprof)
	}
	pprof.StartCPUProfile(f)

	f2, errprof2 := os.Create("memprofile.pprof")
	if errprof2 != nil {
		log.Error(errprof2)
	}*/

	message := new(domain.CreateResourceRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
	}

	//time1 := time.Now()

	log.Info("Proces Create Resource", message)

	response := controller.ProcessCreateResource(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Cabecera != nil {
		response.GetCabecera().TiempoRespuesta = util.Concatenar(response.GetCabecera().TiempoRespuesta)
	}

	//timeMarshal := time.Now()
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		var value []byte
		var err error
		if response != nil {
			value, err = json.Marshal(response)
		}
		if err != nil {
			fmt.Printf("Error Marshalling json: %v", err)
		}
		pResponse.Header().Add("Content-Type", "application/json")
		pResponse.Write(value)
	}

	log.Info("Process Time:")

	// Send ProcessTime for updating service metrics
	go func(pResponse *domain.CreateResourceRS) {
		if pResponse != nil {
			//TODO Insertar codigo aqui
		}
	}(response)

	/*pprof.StopCPUProfile()
	pprof.WriteHeapProfile(f2)*/
}
