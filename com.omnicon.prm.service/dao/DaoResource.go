package dao

import (
	"bytes"
	"fmt"
	"strconv"

	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

/**
*	Name : getProjectCollection
*	Return: db.Collection
*	Description: Get table Project in a session
 */
func getResourceCollection() db.Collection {
	// Get a session
	session = GetSession()
	if session != nil {
		// Return table resource in the session
		return session.Collection("Resource")
	} else {
		return nil
	}
}

/**
*	Name : GetAllResources
*	Return: []*DOMAIN.Resource
*	Description: Get all resources in a resource table
 */
func GetAllResources() []*DOMAIN.Resource {
	// Slice to keep all resources
	var resources []*DOMAIN.Resource
	if getResourceCollection() != nil {
		// Add all resources in resources variable
		err := getResourceCollection().Find().All(&resources)
		// Close session when ends the method
		defer session.Close()
		if err != nil {
			log.Error(err)
		}
	}
	return resources
}

/**
*	Name : GetAllResourcesJoinResourceTypes
*	Return: []*DOMAIN.Resource
*	Description: Get all resources in a resource table
 */
func GetAllResourcesJoinResourceTypes() []*DOMAIN.ResourceQuery {
	// Slice to keep all resources
	var resources []*DOMAIN.ResourceQuery
	ses := GetSession()
	if ses != nil {
		// Add all resources in resources variable
		//err := ses.Select("Resource.id", "name", "last_name", "email", "photo", "engineer_range", "enabled", "visa_us", "resource_id", "type_id", "type_name").From("Resource").Join("ResourceTypes").On("Resource.id = ResourceTypes.resource_id").All(&resources)
		//err := ses.Select("Resource.id", "name", "last_name", "email", "photo", "engineer_range", "enabled", "visa_us", "ResourceTypes.resource_id", "type_id", "type_name", "task", "hours", "project_name").From("Resource").Join("ResourceTypes").On("Resource.id = ResourceTypes.resource_id").Join("ProjectResources").On("Resource.id = ProjectResources.resource_id").All(&resources)
		err := ses.Select("Resource.id", "name", "last_name", "email", "photo", "engineer_range", "enabled", "visa_us", "ResourceTypes.resource_id", "type_id", "type_name", "task", "start_date", "end_date", "hours", "project_name", "asignated_by", "deliverable", "requirements", "priority", "additional_comments").From("Resource").Join("ResourceTypes").On("Resource.id = ResourceTypes.resource_id").Join("ProjectResources").On("Resource.id = ProjectResources.resource_id").All(&resources)

		//err := getResourceCollection().Find().All(&resources)
		// Close session when ends the method
		defer ses.Close()
		if err != nil {
			fmt.Println("qqqqq-->", err)
			log.Error(err)
		}
	}
	return resources
}

/**
*	Name : GetResourceById
*	Params: pId
*	Return: *DOMAIN.Resource
*	Description: Get a resource by ID in a resource table
 */
func GetResourceById(pId int) *DOMAIN.Resource {
	// Resource structure
	resource := DOMAIN.Resource{}
	if getResourceCollection() != nil {
		// Add in resource variable, the resource where ID is the same that the param
		res := getResourceCollection().Find(db.Cond{"id": pId})
		// Close session when ends the method
		defer session.Close()
		err := res.One(&resource)
		if err != nil {
			log.Error(err)
			return nil
		}
	}
	return &resource
}

/**
*	Name : GetResourcesByName
*	Params: pName
*	Return: []*DOMAIN.Resource
*	Description: Get a slice of resource with a name in a resource table
 */
func GetResourcesByName(pName string) []*DOMAIN.Resource {
	// Slice to keep all resources
	resources := []*DOMAIN.Resource{}
	if getResourceCollection() != nil {
		// Filter resources by name
		res := getResourceCollection().Find().Where("name = ?", pName)
		// Close session when ends the method
		defer session.Close()
		// Add all resources in resources variable
		err := res.All(&resources)
		if err != nil {
			log.Error(err)
		}
	}
	return resources
}

/**
*	Name : AddResource
*	Params: pResource
*	Return: int, error
*	Description: Add resource in DB
 */
func AddResource(pResource *DOMAIN.Resource) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Insert in DB
		res, err := session.InsertInto("Resource").Columns(
			"name",
			"last_name",
			"email",
			"photo",
			"engineer_range",
			"enabled",
			"visa_us").Values(
			pResource.Name,
			pResource.LastName,
			pResource.Email,
			pResource.Photo,
			pResource.EngineerRange,
			pResource.Enabled,
			pResource.VisaUS).Exec()
		if err != nil {
			log.Error(err)
			return 0, err
		}
		// Get rows inserted
		insertId, err := res.LastInsertId()
		return int(insertId), nil
	} else {
		return 0, nil
	}
}

/**
*	Name : UpdateResource
*	Params: pResource
*	Return: int, error
*	Description: Update resource in DB
 */
func UpdateResource(pResource *DOMAIN.Resource) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Update resource in DB
		q := session.Update("Resource").Set("name = ?, last_name = ?, email = ?, photo = ?, engineer_range = ?, enabled = ?, visa_us = ?",
			pResource.Name, pResource.LastName, pResource.Email, pResource.Photo, pResource.EngineerRange, pResource.Enabled, pResource.VisaUS).Where("id = ?", int(pResource.ID))
		res, err := q.Exec()
		if err != nil {
			log.Error(err)
			return 0, err
		}
		// Get rows updated
		updateCount, err := res.RowsAffected()
		return int(updateCount), nil
	} else {
		return 0, nil
	}
}

/**
*	Name : DeleteResource
*	Params: pResourceId
*	Return: int, error
*	Description: Delete resource in DB
 */
func DeleteResource(pResourceId int) (int, error) {
	// Get a session
	session = GetSession()
	if session != nil {
		// Close session when ends the method
		defer session.Close()
		// Delete resource in DB
		q := session.DeleteFrom("Resource").Where("id", int(pResourceId))
		res, err := q.Exec()
		if err != nil {
			log.Error(err)
			return 0, err
		}
		// Get rows deleted
		deleteCount, err := res.RowsAffected()
		return int(deleteCount), nil
	} else {
		return 0, nil
	}
}

/**
*	Name : GetResourcesByFilters
*	Params: pResourceFilters, pEnabled
*	Return: []*DOMAIN.Resource
*	Description: Get resources by filters in DB
 */
func GetResourcesByFilters(pResourceFilters *DOMAIN.Resource, pEnabled *bool) ([]*DOMAIN.ResourceQuery, string) {
	// Slice to keep all resources
	resources := []*DOMAIN.ResourceQuery{}
	var stringResponse string

	if getResourceCollection() != nil {
		session.Select("Resource.id", "name", "last_name", "email", "photo", "engineer_range", "enabled", "visa_us", "resource_id", "type_id", "type_name").From("Resource").Join("ResourceTypes").On("Resource.id = ResourceTypes.resource_id")

		result := getResourceCollection().Find()

		// Close session when ends the method
		defer session.Close()

		var filters bytes.Buffer
		if pResourceFilters.ID != 0 {
			filters.WriteString("id = '")
			filters.WriteString(strconv.Itoa(pResourceFilters.ID))
			filters.WriteString("'")
		}
		if pResourceFilters.Name != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("name = '")
			filters.WriteString(pResourceFilters.Name)
			filters.WriteString("'")
		}
		if pResourceFilters.LastName != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("last_name = '")
			filters.WriteString(pResourceFilters.LastName)
			filters.WriteString("'")
		}
		if pResourceFilters.Email != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("email = '")
			filters.WriteString(pResourceFilters.Email)
			filters.WriteString("'")
		}
		if pResourceFilters.EngineerRange != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("engineer_range = '")
			filters.WriteString(pResourceFilters.EngineerRange)
			filters.WriteString("'")
		}
		if pEnabled != nil {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("enabled = '")
			filters.WriteString(strconv.FormatBool(*pEnabled))
			filters.WriteString("'")
		}
		if filters.String() != "" {
			err := result.Where(filters.String()).All(&resources)

			if err != nil {
				log.Error(err)
			}
		}
		stringResponse = filters.String()
	}
	return resources, stringResponse
}

func GetResourcesByFiltersJoinResourceTypes(pResourceFilters *DOMAIN.Resource, pEnabled *bool) ([]*DOMAIN.ResourceQuery, string) {
	// Slice to keep all resources
	resources := []*DOMAIN.ResourceQuery{}
	var stringResponse string
	ses := GetSession()
	if ses != nil {

		result := ses.Select("Resource.id", "name", "last_name", "email", "photo", "engineer_range", "enabled", "visa_us", "ResourceTypes.resource_id", "type_id", "type_name", "task", "start_date", "end_date", "hours", "project_name", "asignated_by", "deliverable", "requirements", "priority", "additional_comments").From("Resource").Join("ResourceTypes").On("Resource.id = ResourceTypes.resource_id").Join("ProjectResources").On("Resource.id = ProjectResources.resource_id")

		//result := getResourceCollection().Find()

		// Close session when ends the method
		//defer session.Close()
		//fmt.Println("%v", pResourceFilters)
		var filters bytes.Buffer
		if pResourceFilters.ID != 0 {
			filters.WriteString("Resource.id = '")
			filters.WriteString(strconv.Itoa(pResourceFilters.ID))
			filters.WriteString("'")
		}
		if pResourceFilters.Name != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("name = '")
			filters.WriteString(pResourceFilters.Name)
			filters.WriteString("'")
		}
		if pResourceFilters.LastName != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("last_name = '")
			filters.WriteString(pResourceFilters.LastName)
			filters.WriteString("'")
		}
		if pResourceFilters.Email != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("email = '")
			filters.WriteString(pResourceFilters.Email)
			filters.WriteString("'")
		}
		if pResourceFilters.TaskStartDate != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("ProjectResources.start_date >= '")
			filters.WriteString(pResourceFilters.TaskStartDate)
			filters.WriteString("'")
		}
		if pResourceFilters.TaskEndDate != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("ProjectResources.end_date <= '")
			filters.WriteString(pResourceFilters.TaskEndDate)
			filters.WriteString("'")
		}
		if pResourceFilters.EngineerRange != "" {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("engineer_range = '")
			filters.WriteString(pResourceFilters.EngineerRange)
			filters.WriteString("'")
		}
		if pEnabled != nil {
			if filters.String() != "" {
				filters.WriteString(" and ")
			}
			filters.WriteString("enabled = '")
			filters.WriteString(strconv.FormatBool(*pEnabled))
			filters.WriteString("'")
		}
		if filters.String() != "" {
			err := result.Where(filters.String()).All(&resources)

			ses.Close()
			if err != nil {
				log.Error(err)
			}
		}
		stringResponse = filters.String()
		fmt.Println("query resourcess--->", result.Where(filters.String()))

	}

	return resources, stringResponse
}
