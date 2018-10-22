package handler

import (
	"encoding/json"
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
	http.HandleFunc("/CreateProjectForecast", createProjectForecast)
	http.HandleFunc("/UpdateProjectForecast", updateProjectForecast)
	http.HandleFunc("/DeleteProjectForecast", deleteProjectForecast)
	// Management Operations
	http.HandleFunc("/SetSkillToResource", setSkillToResource)
	http.HandleFunc("/DeleteSkillToResource", deleteSkillToResource)
	http.HandleFunc("/SetResourceToProject", setResourceToProject)
	http.HandleFunc("/DeleteResourceToProject", deleteResourceToProject)
	http.HandleFunc("/GetResources", getResources)
	http.HandleFunc("/GetProjectsForecast", getProjectsForecast)
	http.HandleFunc("/GetProjects", getProjects)
	http.HandleFunc("/GetSkills", getSkills)
	http.HandleFunc("/GetResourcesToProjects", getResourcesToProjects)
	http.HandleFunc("/GetSkillsByResource", getSkillsToResources)
	http.HandleFunc("/GetTypes", getTypes)
	http.HandleFunc("/CreateType", createType)
	http.HandleFunc("/UpdateType", updateType)
	http.HandleFunc("/DeleteType", deleteType)
	http.HandleFunc("/GetSkillsByType", getSkillsByType)
	http.HandleFunc("/GetTypesByProject", getTypesByProject)
	http.HandleFunc("/DeleteTypesByProject", deleteTypesByProject)
	http.HandleFunc("/DeleteSkillsByType", deleteSkillsByType)
	http.HandleFunc("/SetSkillsToType", setSkillsToType)
	http.HandleFunc("/SetTypesToProject", setTypesToProject)
	http.HandleFunc("/GetTrainingResources", getTrainingResources)
	http.HandleFunc("/GetTrainings", getTrainings)
	http.HandleFunc("/CreateTraining", createTraining)
	http.HandleFunc("/UpdateTraining", updateTraining)
	http.HandleFunc("/DeleteTraining", deleteTraining)
	http.HandleFunc("/GetTypesByResource", getTypesByResource)
	http.HandleFunc("/SetTypesToResource", setTypesToResource)
	http.HandleFunc("/DeleteTypesByResource", deleteTypesByResource)
	http.HandleFunc("/SetTrainingToResource", setTrainingToResource)
	http.HandleFunc("/DeleteTrainingToResource", deleteTrainingToResource)
	http.HandleFunc("/GetSettings", getSettings)
	http.HandleFunc("/UpdateSettings", updateSettings)
	http.HandleFunc("/GetProductivityTasks", getProductivityTasks)
	http.HandleFunc("/CreateProductivityTasks", createProductivityTasks)
	http.HandleFunc("/UpdateProductivityTasks", updateProductivityTasks)
	http.HandleFunc("/DeleteProductivityTasks", deleteProductivityTasks)
	http.HandleFunc("/GetProductivityReport", getProductivityReport)
	http.HandleFunc("/CreateProductivityReport", createProductivityReport)
	http.HandleFunc("/UpdateProductivityReport", updateProductivityReport)
	http.HandleFunc("/DeleteProductivityReport", deleteProductivityReport)
	http.HandleFunc("/GetProjectsByResource", getProjectsByResource)
	http.HandleFunc("/GetPlanning", getPlanning)
	http.HandleFunc("/SubmitChanges", submitChanges)
	http.HandleFunc("/ConfirmChanges", ConfirmChanges)
}

/*
Descripcion : Funcion encargada de crear un recurso de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func createResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("CreateResource")

	message := new(domain.CreateResourceRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Unmarshal error", err)
		}
	}
	log.Info("Process Create Resource", message)
	response := controller.ProcessCreateResource(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de realizar el marshal de la respuesta en formato JSon
	de los servicios.
*/
func marshalJson(pAccept string, pResourceRs interface{}) []byte {
	var value []byte
	if pAccept == "application/json" || strings.Contains(pAccept, "application/json") {
		var err error
		if pResourceRs != nil {
			value, err = json.Marshal(pResourceRs)
		}
		if err != nil {
			log.Debugf("Error Marshalling json: %v", err)
		}
	}
	return value
}

/*
Descripcion : Funcion encargada de actualizar un recurso de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func updateResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("UpdateResource")

	message := new(domain.UpdateResourceRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
	}

	if err != nil {
		log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
	}

	log.Info("Process Update Resource", message)
	response := controller.ProcessUpdateResource(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
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

	startTime := time.Now()

	defer panics.CatchPanic("DeleteResource")

	message := new(domain.DeleteResourceRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}

	log.Info("Process Delete Resource", message)
	response := controller.ProcessDeleteResource(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de crear un proyecto de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func createProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("CreateProject")

	message := new(domain.CreateProjectRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}

	log.Info("Process Create Project", message)

	response := controller.ProcessCreateProject(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de actualizar un proyecto de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func updateProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("UpdateProject")

	message := new(domain.UpdateProjectRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}
	log.Info("Process Update Project", message)
	response := controller.ProcessUpdateProject(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de eliminar un proyecto de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func deleteProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("DeleteProject")

	message := new(domain.DeleteProjectRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}

	log.Info("Process Delete Project", message)
	response := controller.ProcessDeleteProject(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to create a skill according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func createSkill(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("CreateSkill")

	message := new(domain.CreateSkillRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Create Skill", message)
	response := controller.ProcessCreateSkill(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to update a skill according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func updateSkill(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("UpdateSkill")

	message := new(domain.UpdateSkillRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
	log.Info("Process Update Skill", message)
	response := controller.ProcessUpdateSkill(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to delete a skill according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteSkill(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("DeleteSkill")

	message := new(domain.DeleteSkillRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Delete Skill", message)
	response := controller.ProcessDeleteSkill(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de crear un proyecto forecast de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func createProjectForecast(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("CreateProjectForecast")

	message := new(domain.ProjectForecastRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}

	log.Info("Process Create Project Forecast", message)

	response := controller.ProcessCreateProjectForecast(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de actualizar un proyecto forecast de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func updateProjectForecast(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("UpdateProjectForecast")

	message := new(domain.ProjectForecastRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}
	log.Info("Process Update ProjectForecast", message)
	response := controller.ProcessUpdateProjectForecast(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de eliminar un proyecto forecast de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func deleteProjectForecast(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("DeleteProjectForecast")

	message := new(domain.ProjectForecastRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}

	log.Info("Process Delete ProjectForecast", message)
	response := controller.ProcessDeleteProjectForecast(message)

	// Se asigna tiempo de respuesta de todo el proceso.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to set a skill in a resource according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func setSkillToResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("SetSkillToResource")

	message := new(domain.SetSkillToResourceRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Set Skill To Resource", message)
	response := controller.ProcessSetSkillToResource(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to delete a skill in a resource according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteSkillToResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("DeleteSkillToResource")

	message := new(domain.DeleteSkillToResourceRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Delete Skill To Resource", message)
	response := controller.ProcessDeleteSkillToResource(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to set a resource in a project according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func setResourceToProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("SetResourceToProject")

	message := new(domain.SetResourceToProjectRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Set Resource To Project", message)
	response := controller.ProcessSetResourceToProject(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to delete a resource in a project according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteResourceToProject(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("DeleteResourceToProject")

	message := new(domain.DeleteResourceToProjectRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Delete Resource To Project", message)

	response := controller.ProcessDeleteResourceToProject(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get a resources according to filters input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getResources(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("GetResources")

	message := new(domain.GetResourcesRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Resources", message)

	response := controller.ProcessGetResources(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get a projects forecast according to filters input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getProjectsForecast(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("GetProjectsForecast")

	message := new(domain.ProjectForecastRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Projects Forecast", message)

	response := controller.ProcessGetProjectsForecast(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get a projects according to filters input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getProjects(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("GetProjects")

	message := new(domain.GetProjectsRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Projects", message)

	response := controller.ProcessGetProjects(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get all skills according request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getSkills(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("GetSkills")

	message := new(domain.GetSkillsRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Skills", message)
	response := controller.ProcessGetSkills(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get a resources to projects according to filters input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getResourcesToProjects(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("GetResourcesToProjects")

	message := new(domain.GetResourcesToProjectsRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Resources To Projects", message)
	response := controller.ProcessGetResourcesToProjects(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get a skills to resource according to filters input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getSkillsToResources(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("GetSkillsToResources")

	message := new(domain.GetSkillByResourceRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Skills  by Resource", message)
	response := controller.ProcessGetSkillsToResources(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to set a skill to resource according to filters input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func setSkillsToResources(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("SetSkillsToResources")

	message := new(domain.SetSkillToResourceRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Set Skills  by Resource", message)
	response := controller.ProcessSetSkillToResource(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

func getTypes(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("GetTypes")

	message := new(domain.TypeRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Types", message)
	response := controller.ProcessGetTypes(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())

}

/*
Description : Function to create a Types according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func createType(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("CreateType")

	message := new(domain.TypeRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Create Type", message)
	response := controller.ProcessCreateType(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to update a Type according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func updateType(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("UpdateType")

	message := new(domain.TypeRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
	log.Info("Process Update Skill", message)
	response := controller.ProcessUpdateType(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to delete a Type according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteType(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("DeleteType")

	message := new(domain.TypeRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Delete Skill", message)
	response := controller.ProcessDeleteType(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

func getSkillsByType(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("GetSkillsByType")

	message := new(domain.TypeRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Skills by Type", message)
	response := controller.ProcessGetSkillsByType(message)

	// Set response time to all process.
	// TODO ?????????? why???
	/*if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}*/

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

func getTypesByProject(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("GetTypesByProject")

	message := new(domain.GetProjectsRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Types by ProjectId", message)
	response := controller.ProcessGetTypesByProject(message)

	// Set response time to all process.
	// TODO ?????????? why???
	/*if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}*/

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())

}

func deleteSkillsByType(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("deleteSkillsByType")

	message := new(domain.TypeSkillsRQ)
	getMessage(pRequest, message)

	response := controller.ProcessDeleteSkillsByType(message)
	value := marshalJson(pRequest.Header.Get("Accept"), response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())

}

func deleteTypesByProject(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("deleteTypesByProject")

	message := new(domain.ProjectTypesRQ)
	getMessage(pRequest, message)

	response := controller.ProcessDeleteTypesByProject(message)

	value := marshalJson(pRequest.Header.Get("Accept"), response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

func getMessage(pRequest *http.Request, messageRQ interface{}) {
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&messageRQ)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
}

func setSkillsToType(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("setSkillsToType")

	message := new(domain.TypeSkillsRQ)
	getMessage(pRequest, message)

	response := controller.ProcessSetSkillsByType(message)
	value := marshalJson(pRequest.Header.Get("Accept"), response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

func setTypesToProject(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("setTypesToProject")

	message := new(domain.ProjectTypesRQ)
	getMessage(pRequest, message)

	response := controller.ProcessSetTypesByProject(message)
	value := marshalJson(pRequest.Header.Get("Accept"), response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())

}

/*
Descripcion : Funcion encargada de crear un Training  de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func createTraining(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("CreateTraining")

	message := new(domain.TrainingRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}

	log.Info("Process Create Training", message)

	response := controller.ProcessCreateTraining(message)

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de obtener un Training  de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func getTrainingResources(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("GetTrainingResources")

	message := new(domain.TrainingResourcesRQ)
	getMessage(pRequest, message)
	log.Info("Process Get Training Resources", message)

	response := controller.ProcessGetTrainingResources(message)
	log.Debug("Response", response.Status)
	log.Debug("Response.Training", len(response.FilteredTrainings))
	log.Debug("Response.TrainingResources", len(response.TrainingResources))
	value := marshalJson(pRequest.Header.Get("Accept"), response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get all trainings according request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getTrainings(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("GetTrainings")

	message := new(domain.TrainingRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Trainings", message)
	response := controller.ProcessGetTrainings(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to update a skill according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func updateTraining(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("UpdateTraining")

	message := new(domain.TrainingRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
	log.Info("Process Update Training", message)
	response := controller.ProcessUpdateTraining(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to delete a training according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteTraining(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("DeleteTraining")

	message := new(domain.TrainingRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Delete Training", message)
	response := controller.ProcessDeleteTraining(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

func getTypesByResource(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("GetTypesByResource")

	message := new(domain.GetResourcesRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Types by ResourceId", message)
	response := controller.ProcessGetTypesByResource(message)

	// Set response time to all process.
	// TODO ?????????? why???
	/*if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}*/

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())

}

func setTypesToResource(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("setTypesToResource")

	message := new(domain.ResourceTypesRQ)
	getMessage(pRequest, message)

	response := controller.ProcessSetTypesByResource(message)
	value := marshalJson(pRequest.Header.Get("Accept"), response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())

}

func deleteTypesByResource(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("deleteTypesByResource")

	message := new(domain.ResourceTypesRQ)
	getMessage(pRequest, message)

	response := controller.ProcessDeleteTypesByResource(message)

	value := marshalJson(pRequest.Header.Get("Accept"), response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to set a training in a resource according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func setTrainingToResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("SetTrainingToResource")

	message := new(domain.TrainingResourcesRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Set Training To Resource", message)
	response := controller.ProcessSetTrainingToResource(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to delete a training in a resource according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteTrainingToResource(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("DeleteTrainingToResource")

	message := new(domain.TrainingResourcesRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Delete Training To Resource", message)
	response := controller.ProcessDeleteTrainingToResource(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get all settings according request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getSettings(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("GetSettings")

	message := new(domain.SettingsRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get Settings", message)
	response := controller.ProcessGetSettings(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to update a setting according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func updateSettings(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("UpdateSettings")

	message := new(domain.SettingsRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
	log.Info("Process Update Settings", message)
	response := controller.ProcessUpdateSettings(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de crear un ProductivityTasks  de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func createProductivityTasks(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("CreateProductivityTasks")

	message := new(domain.ProductivityTasksRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}

	log.Info("Process Create ProductivityTasks", message)

	response := controller.ProcessCreateProductivityTasks(message)

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get all ProductivityTasks according request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getProductivityTasks(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("GetProductivityTasks")

	message := new(domain.ProductivityTasksRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get ProductivityTasks", message)
	response := controller.ProcessGetProductivityTasks(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to update a ProductivityTasks according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func updateProductivityTasks(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("UpdateProductivityTasks")

	message := new(domain.ProductivityTasksRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
	log.Info("Process Update ProductivityTasks", message)
	response := controller.ProcessUpdateProductivityTasks(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to delete a productivityTasks according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteProductivityTasks(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("DeleteProductivityTasks")

	message := new(domain.ProductivityTasksRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Delete ProductivityTasks", message)
	response := controller.ProcessDeleteProductivityTasks(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Descripcion : Funcion encargada de crear un ProductivityReport  de acuerdo a la peticion de entrada.

Parametros :
      pResponse http.ResponseWriter :  contiene la respuesta que se enviara al usuario
	  pRequest *http.Request :         Contiene la peticion del usuario
*/
func createProductivityReport(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("CreateProductivityReport")

	message := new(domain.ProductivityReportRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Ha ocurrido un error al realizar el Unmarshal", err)
		}
	}

	log.Info("Process Create ProductivityReport", message)

	response := controller.ProcessCreateProductivityReport(message)

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get all ProductivityReport according request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getProductivityReport(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()
	defer panics.CatchPanic("GetProductivityReport")

	message := new(domain.ProductivityReportRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Get ProductivityReport", message)
	response := controller.ProcessGetProductivityReport(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to update a ProductivityReport according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func updateProductivityReport(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("UpdateProductivityReport")

	message := new(domain.ProductivityReportRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
	log.Info("Process Update ProductivityReport", message)
	response := controller.ProcessUpdateProductivityReport(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to delete a productivityReport according to input request.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func deleteProductivityReport(pResponse http.ResponseWriter, pRequest *http.Request) {

	startTime := time.Now()

	defer panics.CatchPanic("DeleteProductivityReport")

	message := new(domain.ProductivityReportRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Delete ProductivityReport", message)
	response := controller.ProcessDeleteProductivityReport(message)

	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.Header.ResponseTime = util.Concatenate(response.Header.ResponseTime)
	}

	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to get all the projects associated to an especified Resource.

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getProjectsByResource(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("GetProjectsByResource")

	message := new(domain.GetResourcesToProjectsRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
	log.Info("Process Get Projects By Resource", message)
	response := controller.ProcessGetProjectsByResource(message)
	// Set response time to all process.
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}

	value := marshalJson(accept, response)

	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to creates or edits a register an assignation in the planning

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func submitChanges(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("SubmitChanges")

	message := new(domain.PlanningRQ)
	accept := pRequest.Header.Get("Accept")

	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}

	log.Info("Process Submit Changes", message)
	response := controller.ProcessSubmitChanges(message)

	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}
	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)
	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to the get all the information in the planning table

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func getPlanning(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("GetPlanning")

	message := new(domain.GetPlanningRQ)
	accept := pRequest.Header.Get("Accept")
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
	log.Info("Process Get Planning", message)
	response := controller.ProcessGetPlanning(message)
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}
	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)

	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}

/*
Description : Function to the get all the information in the planning table

Params :
      pResponse http.ResponseWriter :  Contain the response that will be sent to the user
	  pRequest *http.Request :         Contain the user's request
*/
func ConfirmChanges(pResponse http.ResponseWriter, pRequest *http.Request) {
	startTime := time.Now()
	defer panics.CatchPanic("ConfirmChanges")
	message := new(domain.GetPlanningRQ)
	accept := pRequest.Header.Get("Accept")
	var err error
	if accept == "application/json" || strings.Contains(accept, "application/json") {
		err = json.NewDecoder(pRequest.Body).Decode(&message)
		if err != nil {
			log.Error("Error in Unmarshal process", err)
		}
	}
	log.Info("Process Confirm Changes Planning", message)
	response := controller.ProcessConfirmPlanning()
	if response != nil && response.Header != nil {
		response.GetHeader().ResponseTime = util.Concatenate(response.GetHeader().ResponseTime)
	}
	value := marshalJson(accept, response)
	pResponse.Header().Add("Content-Type", "application/json")
	pResponse.Write(value)
	processTime := time.Now().Sub(startTime)
	log.Info("Process Time:", processTime.String())
}
