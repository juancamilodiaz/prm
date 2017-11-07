package dao

import (
	"sort"

	"prm/com.omnicon.prm.service/domain"
)

type ByStartDate []*domain.ProjectResources

func (a ByStartDate) Len() int { return len(a) }

func (a ByStartDate) Swap(i, j int) { a[i], a[j] = a[j], a[i] }

//Overwrite function Less de sort
func (a ByStartDate) Less(i, j int) bool {
	return a[i].StartDate.Unix() < a[j].StartDate.Unix()
}

//Call sort function with list of ProjectResources by StartDate ASC.
func SortByStartDate(pListProjectResources []*domain.ProjectResources) {
	sort.Sort(ByStartDate(pListProjectResources))
}
