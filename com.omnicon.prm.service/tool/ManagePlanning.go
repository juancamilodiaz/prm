package tool

import (
	"strconv"
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/util"
)

/**
* Function to create a new or edit a register in the planning table
 */
func SubmitChanges(pRequest *DOMAIN.PlanningRQ) *DOMAIN.UpdatePlanningRS {
	timeResponse := time.Now()
	response := DOMAIN.UpdatePlanningRS{}

	if pRequest.Id != 0 {
		// update register
		_, err := dao.UpdatePlanning(pRequest)
		response.PlanningId = pRequest.Id
		response.Error = err

	} else {
		// insert new register
		res, err := dao.InsertPlanning(pRequest)
		response.PlanningId = res
		response.Error = err
	}
	response.Header = util.BuildHeaderResponse(timeResponse)
	return &response
}

/*
* Function to get the planning
 */
func GetPlanning(pRequest *DOMAIN.GetPlanningRQ) *DOMAIN.PlanningRS {
	response := DOMAIN.PlanningRS{}
	response.Planning = dao.GetPlanning(pRequest)
	return &response
}

/*
* Function to save the planning into the ProjectResources Table
 */
func ConfirmPlanning() *DOMAIN.UpdatePlanningRS {
	response := DOMAIN.UpdatePlanningRS{}
	res, err := dao.ConfirmPlanning()
	response.Status = strconv.Itoa(res)
	response.Error = err
	return &response
}
