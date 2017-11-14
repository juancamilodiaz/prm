package tool

import (
	"time"

	"prm/com.omnicon.prm.service/dao"
	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

/*
* Get all elements of settings from the request values
 */
func GetSettings(pRequest *DOMAIN.SettingsRQ) *DOMAIN.SettingsRS {
	timeResponse := time.Now()
	response := DOMAIN.SettingsRS{}
	filters := util.MappingFiltersSettings(pRequest)
	settings, filterString := dao.GetSettingsByFilters(filters)

	if len(settings) == 0 && filterString == "" {
		settings = dao.GetAllSettings()
	}

	if settings != nil && len(settings) > 0 {

		response.Settings = settings
		// Create response
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Settings wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}

/**
* Function to update a settings from SettingsRQ
 */
func UpdateSettings(pRequest *DOMAIN.SettingsRQ) *DOMAIN.SettingsRS {
	timeResponse := time.Now()
	response := DOMAIN.SettingsRS{}
	oldSettings := dao.GetSettingsById(pRequest.ID)
	if oldSettings != nil {
		if pRequest.Name != "" {
			oldSettings.Name = pRequest.Name
		}
		if pRequest.Value != "" {
			oldSettings.Value = pRequest.Value
		}
		if pRequest.Type != "" {
			oldSettings.Type = pRequest.Type
		}
		// Save in DB
		rowsUpdated, err := dao.UpdateSettings(oldSettings)
		if err != nil || rowsUpdated <= 0 {
			message := "Settings wasn't update"
			log.Error(message)
			response.Message = message
			response.Status = "Error"
			return &response
		}
		response.Status = "OK"

		response.Header = util.BuildHeaderResponse(timeResponse)

		return &response
	}

	message := "Settings wasn't found in DB"
	log.Error(message)
	response.Message = message
	response.Status = "Error"

	response.Header = util.BuildHeaderResponse(timeResponse)

	return &response
}
