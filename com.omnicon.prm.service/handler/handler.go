package handler

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"

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
	http.HandleFunc("/UpdateResource", updateResource)
	http.HandleFunc("/CreateProject", createProject)
	http.HandleFunc("/UpdateProject", updateProject)
}

/*
Descripcion : Funcion encargada de crear un recurso de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func createResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

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
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenar(response.GetHeader().ResponseTime)
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

	processTime := time.Now().Sub(StartTime)
	log.Info("Process Time:", processTime.String())

	// Send ProcessTime for updating service metrics
	go func(pResponse *domain.CreateResourceRS) {
		if pResponse != nil {
			//TODO Insertar codigo aqui
		}
	}(response)

	/*pprof.StopCPUProfile()
	pprof.WriteHeapProfile(f2)*/
}

/*
Descripcion : Funcion encargada de actualizar un recurso de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func updateResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("UpdateResource")

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

	message := new(domain.UpdateResourceRQ)
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

	log.Info("Proces Update Resource", message)

	response := controller.ProcessUpdateResource(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenar(response.GetHeader().ResponseTime)
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

	processTime := time.Now().Sub(StartTime)
	log.Info("Process Time:", processTime.String())

	// Send ProcessTime for updating service metrics
	go func(pResponse *domain.UpdateResourceRS) {
		if pResponse != nil {
			//TODO Insertar codigo aqui
		}
	}(response)

	/*pprof.StopCPUProfile()
	pprof.WriteHeapProfile(f2)*/
}

/*
Descripcion : Funcion encargada de crear un proyecto de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func createProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("CreateProject")

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

	message := new(domain.CreateProjectRQ)
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

	log.Info("Proces Create Project", message)

	response := controller.ProcessCreateProject(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenar(response.GetHeader().ResponseTime)
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

	processTime := time.Now().Sub(StartTime)
	log.Info("Process Time:", processTime.String())

	// Send ProcessTime for updating service metrics
	go func(pResponse *domain.CreateProjectRS) {
		if pResponse != nil {
			//TODO Insertar codigo aqui
		}
	}(response)

	/*pprof.StopCPUProfile()
	pprof.WriteHeapProfile(f2)*/
}

/*
Descripcion : Funcion encargada de actualizar un proyecto de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func updateProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("UpdateProject")

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

	message := new(domain.UpdateProjectRQ)
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

	log.Info("Proces Update Project", message)

	response := controller.ProcessUpdateProject(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenar(response.GetHeader().ResponseTime)
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

	processTime := time.Now().Sub(StartTime)
	log.Info("Process Time:", processTime.String())

	// Send ProcessTime for updating service metrics
	go func(pResponse *domain.UpdateProjectRS) {
		if pResponse != nil {
			//TODO Insertar codigo aqui
		}
	}(response)

	/*pprof.StopCPUProfile()
	pprof.WriteHeapProfile(f2)*/
}
