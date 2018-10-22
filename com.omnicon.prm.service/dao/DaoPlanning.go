package dao

import (
	"fmt"
	"sync"
	"time"

	"github.com/jinzhu/now"

	"upper.io/db.v3/lib/sqlbuilder"

	DOMAIN "prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3"
)

func getPlanningCollection() db.Collection {
	session = GetSession()
	if session != nil {
		//Return table planning in the session
		return session.Collection("Planning")
	} else {
		return nil
	}
}

/**
*	Name : UpdatePlanning
*	Params: pRequest
*	Return: int, error
*	Description: Update planning in DB
 */
func UpdatePlanning(pRequest *DOMAIN.PlanningRQ) (int, error) {
	session = GetSession()

	if session != nil {
		defer session.Close()

		q := session.Update("Planning").Set(pRequest.Field+" = '"+pRequest.Value+"'").Where("Id = ?", int(pRequest.Id))
		_, err := q.Exec()
		if err != nil {
			log.Error(err)
			return 0, err
		}
		return 1, nil
	} else {
		return 0, nil
	}

}

/**
*	Name : InsertPlanning
*	Params: pRequest
*	Return: int, error
*	Description: Insert Planning in DB
 */
func InsertPlanning(pRequest *DOMAIN.PlanningRQ) (int, error) {
	session = GetSession()
	if session != nil {

		defer session.Close()
		var mutex = &sync.Mutex{}
		mutex.Lock()
		defer mutex.Unlock()

		// insert the new register into the Planning table
		res, err := session.InsertInto("Planning").Columns(
			pRequest.Field).Values(
			pRequest.Value).Exec()

		if err != nil {
			log.Error(err)
			return 0, err
		}
		insertedID, err := res.LastInsertId()
		return int(insertedID), nil
	} else {
		return 0, nil
	}

}

func getDateByISOWeek(ISOWeek int, year int) (time.Time, time.Time) {
	date := time.Date(year, time.January, 1, 0, 0, 0, 0, time.UTC)
	date = date.Add(time.Hour * (24 * 7 * (time.Duration(ISOWeek) - 1)))
	initial := now.New(date).BeginningOfWeek()
	end := now.New(date).EndOfWeek()
	return initial, end
}

/**
*	Name : GetPlanning
*	Params: pRequest
*	Return: []*DOMAIN.Planning
*	Description: Get All the planning stored in the database
 */
func GetPlanning(pRequest *DOMAIN.GetPlanningRQ) []*DOMAIN.Planning {

	fmt.Printf("%+v\n", pRequest)
	startDate, endDate := getDateByISOWeek(pRequest.Week, 2018)
	fmt.Println("The date is", startDate, endDate)

	session = GetSession()
	var Planning []*DOMAIN.Planning
	var PlanningResponse []*DOMAIN.Planning
	if session != nil {
		defer session.Close()

		rows, err := session.Query(`select Planning.Id, 
		isnull(ResourceTypes.[type_name], '') as type_name, 
		([Resource].[name] + ' ' + [Resource].last_name) as Engineer, 
		Planning.Activity,
		Planning.Deliverable,
		Planning.Requirements, 
		Planning.StartDate,
		Planning.EndDate,
		Planning.TimeAssigned as [Time],
		Planning.[Priority],
		Project.[name] as Project,
		Planning.AdditionalComments,
		(Assigner.[name] + ' ' + Assigner.last_name) as AssignedBy
	  from Planning
		left join [Resource] on Planning.ResourceId = [Resource].id
		  left join ResourceTypes on [Resource].id = ResourceTypes.resource_id
		  left join Project on Planning.ProjectId = Project.id
		  left join [Resource] as Assigner on Assigner.id = Planning.AssignedBy
	where ( Planning.StartDate >= '` + startDate.Format("2006-01-02") + `' and Planning.StartDate <= '` + endDate.Format("2006-01-02") + `' and Planning.EndDate <= '` + endDate.Format("2006-01-02") + `' and Planning.EndDate >= '` + startDate.Format("2006-01-02") + `' ) or
		(Planning.StartDate < '` + startDate.Format("2006-01-02") + `' and Planning.EndDate <= '` + endDate.Format("2006-01-02") + `' and Planning.EndDate >= '` + startDate.Format("2006-01-02") + `') or
		(Planning.StartDate >= '` + startDate.Format("2006-01-02") + `' and Planning.StartDate <= '` + endDate.Format("2006-01-02") + `'  and Planning.EndDate > '` + endDate.Format("2006-01-02") + `') or
		(Planning.StartDate < '` + startDate.Format("2006-01-02") + `' and Planning.EndDate > '` + endDate.Format("2006-01-02") + `')
	`)

		if err != nil {
			return Planning
		}
		iter := sqlbuilder.NewIterator(rows)
		iter.All(&Planning)

		var res bool
		var index int

		for _, element := range Planning {
			res, index = ContainsPlanning(PlanningResponse, element.Id)
			element.ResourceType = append(element.ResourceType, element.Type)
			if res {
				// if the element was already added
				PlanningResponse[index].ResourceType = append(PlanningResponse[index].ResourceType, element.Type)
			} else {
				// if the element is not added yet
				// check if the time assigned is correct
				if element.StartDate < startDate && element.EndDate <= endDate {
					//time assigned is the diff between startDate and element.EndDate
				} else if element.EndDate > endDate && element.StartDate >= startDate {
					//time assigned is the diff between element.StartDate and endDate
				} else if element.StartDate < startDate && element.EndDate > endDate {
					//time assigned is 45 hours
				}

				PlanningResponse = append(PlanningResponse, element)
			}
		}
	}
	return PlanningResponse
}

//Function to determine if a planning element is contained in the planning array
func ContainsPlanning(Planning []*DOMAIN.Planning, Id int) (bool, int) {
	for index, element := range Planning {
		if Id == element.Id {
			return true, index
		}
	}
	return false, 0
}

/**
*	Name : ConfirmPlanning
*	Params: pRequest
*	Return: int, error
*	Description: Insert Planning in DB
 */
func ConfirmPlanning() (int, error) {
	session = GetSession()
	if session != nil {
		defer session.Close()
		_, err := session.Exec(`
		insert into ProjectResources
		SELECT
			  ProjectId,
			  ResourceId,
			  Project.[name] as ProjectName,
			  [Resource].[name] + ' ' + [Resource].last_name as ResourceName,
			  Planning.StartDate,
			  Planning.EndDate,
			  Planning.TimeAssigned as [Hours],
			  0 as Lead,
			  Activity as Task,
			  AssignedBy,
			  Deliverable,
			  Requirements,
			  [Priority],
			  AdditionalComments
		FROM [Planning]
		left join Project on Project.id = Planning.ProjectId
		left join [Resource] on [Resource].id = Planning.ResourceId	  
		`)
		if err != nil {
			return 0, err
		}
		return 1, err
	}
	return 0, nil
}
