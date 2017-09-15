package util

import (
	"time"

	"prm/com.omnicon.prm.service/log"
)

// If the dates are valid return true, start date minor that end date
func ValidateDates(pStartDate, pEndDate *string, pIsCreate bool) (bool, string) {
	var message string

	if pStartDate == nil {
		startDateTmp := ""
		pStartDate = &startDateTmp
	}
	if pEndDate == nil {
		endDateTmp := ""
		pEndDate = &endDateTmp
	}

	if pIsCreate {
		if *pStartDate == "" && *pEndDate == "" {
			*pStartDate = time.Now().Format("2006-01-02")
			*pEndDate = time.Now().AddDate(0, 1, 0).Format("2006-01-02")
		} else if *pStartDate != "" && *pEndDate == "" {
			startDate, err := time.Parse("2006-01-02", *pStartDate)
			if err == nil {
				*pEndDate = startDate.AddDate(0, 1, 0).Format("2006-01-02")
			}
		} else if *pStartDate == "" && *pEndDate != "" {
			endDate, err := time.Parse("2006-01-02", *pEndDate)
			if err == nil {
				if time.Now().Unix() <= endDate.Unix() {
					*pStartDate = time.Now().Format("2006-01-02")
				}
			}
		}
	}

	var startDate, endDate time.Time
	var err error
	if *pStartDate != "" {
		startDate, err = time.Parse("2006-01-02", *pStartDate)
		if err != nil {
			message = "The start date is incorrect, format should be YYYY-MM-DD."
			log.Error(message)
			return false, message
		}
	}
	if *pEndDate != "" {
		endDate, err = time.Parse("2006-01-02", *pEndDate)
		if err != nil {
			message = "The end date is incorrect, format should be YYYY-MM-DD."
			log.Error(message)
			return false, message
		}
	}

	if *pStartDate != "" && *pEndDate != "" {
		if startDate.Unix() > endDate.Unix() {
			message = "The start date is greater than the end date."
			log.Error(message)
			return false, message
		}
	}
	return true, ""
}
