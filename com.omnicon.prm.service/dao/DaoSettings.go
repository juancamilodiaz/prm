package dao

import (
	"bytes"
	"strconv"

	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getSettingsCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getSettingsCollection() db.Collection {
	// Get a session
	session = GetSession()
	// Return table resource in the session
	return session.Collection("Settings")
}

/**
*	Name : GetAllSettings
*	Return: []*DOMAIN.Settings
*	Description: Get all settings in a settings table
 */
func GetAllSettings() []*DOMAIN.Settings {
	// Slice to keep all Settings
	var settings []*DOMAIN.Settings
	// Add all Settings in resources variable
	err := getSettingsCollection().Find().All(&settings)
	// Close session when ends the method
	defer session.Close()
	if err != nil {
		log.Error(err)
	}
	return settings
}

/**
*	Name : GetSettingsById
*	Params: pId
*	Return: *DOMAIN.Settings
*	Description: Get a Setting by ID in a Settings table
 */
func GetSettingsById(pId int) *DOMAIN.Settings {
	// Settings structure
	settings := DOMAIN.Settings{}
	// Add in Settings variable, the Settings where ID is the same that the param
	res := getSettingsCollection().Find(db.Cond{"id": pId})
	log.Debug("find Settings by ID:", pId)
	// Close session when ends the method
	defer session.Close()
	err := res.One(&settings)
	if err != nil {
		log.Error(err)
		return nil
	}
	log.Debug("Result:", settings)
	return &settings
}

/**
*	Name : GetSettingsByName
*	Params: pId
*	Return: *DOMAIN.Settings
*	Description: Get a Settings by Type ID in a Settings table
 */
func GetSettingsByName(pName string) []*DOMAIN.Settings {
	// Settings structure
	settings := []*DOMAIN.Settings{}
	// Add in Settings variable, the Settings where ID is the same that the param
	res := getSettingsCollection().Find().Where("name = ?", pName)
	// Close session when ends the method
	defer session.Close()
	err := res.All(&settings)
	if err != nil {
		log.Error(err)
		return nil
	}
	return settings
}

/**
*	Name : UpdateSettings
*	Params: pSettings
*	Return: int, error
*	Description: Update settings in DB
 */
func UpdateSettings(pSettings *DOMAIN.Settings) (int, error) {
	// Get a session
	session = GetSession()
	// Close session when ends the method
	defer session.Close()
	// Update skill in DB
	q := session.Update("Settings").Set("name = ?, value = ?, type = ?", pSettings.Name, pSettings.Value, pSettings.Type).Where("id = ?", pSettings.ID)
	res, err := q.Exec()
	if err != nil {
		log.Error(err)
		return 0, err
	}
	// Get rows updated
	updateCount, err := res.RowsAffected()
	return int(updateCount), nil
}

/**
*	Name : GetSettingsByFilters
*	Params: pSettingsFilters
*	Return: []*DOMAIN.Settings
*	Description: Get a slice of settings from settings table
 */
func GetSettingsByFilters(pSettingsFilters *DOMAIN.Settings) ([]*DOMAIN.Settings, string) {
	// Slice to keep all settings
	settings := []*DOMAIN.Settings{}
	// Filter settings
	result := getSettingsCollection().Find()

	// Close session when ends the method
	defer session.Close()

	var filters bytes.Buffer
	if pSettingsFilters.ID != 0 {
		filters.WriteString("id = '")
		filters.WriteString(strconv.Itoa(pSettingsFilters.ID))
		filters.WriteString("'")
	}
	if pSettingsFilters.Name != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("name = '")
		filters.WriteString(pSettingsFilters.Name)
		filters.WriteString("'")
	}
	if pSettingsFilters.Value != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("value = '")
		filters.WriteString(pSettingsFilters.Value)
		filters.WriteString("'")
	}
	if pSettingsFilters.Type != "" {
		if filters.String() != "" {
			filters.WriteString(" and ")
		}
		filters.WriteString("type = '")
		filters.WriteString(pSettingsFilters.Type)
		filters.WriteString("'")
	}

	if filters.String() != "" {
		// Add all settings in settings variable
		err := result.Where(filters.String()).All(&settings)
		if err != nil {
			log.Error(err)
		}
	}
	return settings, filters.String()
}
