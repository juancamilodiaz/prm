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
	// CUD Operations
	http.HandleFunc("/CreateResource", createResource)
	http.HandleFunc("/UpdateResource", updateResource)
	http.HandleFunc("/DeleteResource", deleteResource)
	http.HandleFunc("/CreateProject", createProject)
	http.HandleFunc("/UpdateProject", updateProject)
	http.HandleFunc("/DeleteProject", deleteProject)
	http.HandleFunc("/CreateSkill", createSkill)
	http.HandleFunc("/UpdateSkill", updateSkill)
	http.HandleFunc("/DeleteSkill", deleteSkill)
	// Management Operations
	http.HandleFunc("/SetSkillToResource", setSkillToResource)
	http.HandleFunc("/DeleteSkillToResource", deleteSkillToResource)
	http.HandleFunc("/SetResourceToProject", setResourceToProject)
	http.HandleFunc("/DeleteResourceToProject", deleteResourceToProject)
	http.HandleFunc("/GetResources", getResources)
	http.HandleFunc("/GetProjects", getProjects)
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

	log.Info("Process Create Resource", message)

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

	log.Info("Process Update Resource", message)

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
}

/*
Descripcion : Funcion encargada de eliminar un recurso de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func deleteResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("DeleteResource")

	message := new(domain.DeleteResourceRQ)
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

	log.Info("Process Delete Resource", message)

	response := controller.ProcessDeleteResource(message)

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
	go func(pResponse *domain.DeleteResourceRS) {
		if pResponse != nil {
			//TODO Insertar codigo aqui
		}
	}(response)
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

	log.Info("Process Create Project", message)

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

	log.Info("Process Update Project", message)

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
}

/*
Descripcion : Funcion encargada de eliminar un proyecto de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func deleteProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("DeleteProject")

	message := new(domain.DeleteProjectRQ)
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

	log.Info("Process Delete Project", message)

	response := controller.ProcessDeleteProject(message)

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
	go func(pResponse *domain.DeleteProjectRS) {
		if pResponse != nil {
			//TODO Insertar codigo aqui
		}
	}(response)
}

/*
Description : Function to create a skill according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func createSkill(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("CreateSkill")

	message := new(domain.CreateSkillRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Error in Unmarshal process", err)
	}

	//time1 := time.Now()

	log.Info("Process Create Skill", message)

	response := controller.ProcessCreateSkill(message)

	// Set response time to all process.
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
	go func(pResponse *domain.CreateSkillRS) {
		if pResponse != nil {
			//TODO Insert code here
		}
	}(response)
}

/*
Description : Function to update a skill according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func updateSkill(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("UpdateSkill")

	message := new(domain.UpdateSkillRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Error in Unmarshal process", err)
	}

	//time1 := time.Now()

	log.Info("Process Update Skill", message)

	response := controller.ProcessUpdateSkill(message)

	// Set response time to all process.
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
	go func(pResponse *domain.UpdateSkillRS) {
		if pResponse != nil {
			//TODO Insert code here
		}
	}(response)
}

/*
Description : Function to delete a skill according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteSkill(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("DeleteSkill")

	message := new(domain.DeleteSkillRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Error in Unmarshal process", err)
	}

	//time1 := time.Now()

	log.Info("Process Delete Skill", message)

	response := controller.ProcessDeleteSkill(message)

	// Set response time to all process.
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
	go func(pResponse *domain.DeleteSkillRS) {
		if pResponse != nil {
			//TODO Insert code here
		}
	}(response)
}

/*
Description : Function to set a skill in a resource according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func setSkillToResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("SetSkillToResource")

	message := new(domain.SetSkillToResourceRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Error in Unmarshal process", err)
	}

	//time1 := time.Now()

	log.Info("Process Set Skill To Resource", message)

	response := controller.ProcessSetSkillToResource(message)

	// Set response time to all process.
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
	go func(pResponse *domain.SetSkillToResourceRS) {
		if pResponse != nil {
			//TODO Insert code here
		}
	}(response)
}

/*
Description : Function to delete a skill in a resource according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteSkillToResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("DeleteSkillToResource")

	message := new(domain.DeleteSkillToResourceRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Error in Unmarshal process", err)
	}

	//time1 := time.Now()

	log.Info("Process Delete Skill To Resource", message)

	response := controller.ProcessDeleteSkillToResource(message)

	// Set response time to all process.
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
	go func(pResponse *domain.DeleteSkillToResourceRS) {
		if pResponse != nil {
			//TODO Insert code here
		}
	}(response)
}

/*
Description : Function to set a resource in a project according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func setResourceToProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("SetResourceToProject")

	message := new(domain.SetResourceToProjectRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Error in Unmarshal process", err)
	}

	//time1 := time.Now()

	log.Info("Process Set Resource To Project", message)

	response := controller.ProcessSetResourceToProject(message)

	// Set response time to all process.
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
	go func(pResponse *domain.SetResourceToProjectRS) {
		if pResponse != nil {
			//TODO Insert code here
		}
	}(response)
}

/*
Description : Function to delete a resource in a project according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteResourceToProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("DeleteResourceToProject")

	message := new(domain.DeleteResourceToProjectRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Error in Unmarshal process", err)
	}

	//time1 := time.Now()

	log.Info("Process Delete Resource To Project", message)

	response := controller.ProcessDeleteResourceToProject(message)

	// Set response time to all process.
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
	go func(pResponse *domain.DeleteResourceToProjectRS) {
		if pResponse != nil {
			//TODO Insert code here
		}
	}(response)
}

/*
Description : Function to get a resources according to filters input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getResources(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("GetResources")

	message := new(domain.GetResourcesRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Error in Unmarshal process", err)
	}

	//time1 := time.Now()

	log.Info("Process Get Resources", message)

	response := controller.ProcessGetResources(message)

	// Set response time to all process.
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
	go func(pResponse *domain.GetResourcesRS) {
		if pResponse != nil {
			//TODO Insert code here
		}
	}(response)
}

/*
Description : Function to get a projects according to filters input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getProjects(pResponse http.ResponseWriter, pRequest *http.Request) {

	StartTime := time.Now()

	defer panics.CatchPanic("GetProjects")

	message := new(domain.GetProjectsRQ)
	accept := pRequest.Header.Get("Accept")
	//timeUnmarshal := time.Now()
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Error in Unmarshal process", err)
	}

	//time1 := time.Now()

	log.Info("Process Get Projects", message)

	response := controller.ProcessGetProjects(message)

	// Set response time to all process.
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
	go func(pResponse *domain.GetProjectsRS) {
		if pResponse != nil {
			//TODO Insert code here
		}
	}(response)
}
