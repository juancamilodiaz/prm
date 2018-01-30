package report

import (
	"strconv"
	"time"

	"encoding/json"

	"os"

	"github.com/jung-kurt/gofpdf"
	utilr "prm/com.omnicon.prm.reports/util"
	"prm/com.omnicon.prm.service/dao"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/util"
)

func init() {
	createFolder()
	time.Local = time.UTC
}

func ProjectAssign(pInput domain.GetResourcesToProjectsRQ) string {

	filePDF := "ProjectAssign.pdf"
	deleteFile(filePDF)

	pdf := gofpdf.New("P", "mm", "letter", "")

	resourceToProjects := getProjectAssign(pInput)
	template := buildTemplate("Project Assign", pdf)

	wTable := []float64{70, 30, 30, 20, 40}
	wSum := 0.0
	for _, v := range wTable {
		wSum += v
	}

	projectTable := func() {

		pdf.AddPage()
		pdf.UseTemplate(template)
		pdf.SetY(pdf.GetY() + 30)

		for nameProject, project := range resourceToProjects {
			fill := false

			var dates string
			if len(project) > 0 {
				projectInfo := GetAllProjects(domain.GetProjectsRQ{ID: project[0].ProjectId})
				if len(projectInfo) == 1 {
					dates = util.Concatenate("From: ", projectInfo[0].StartDate.Format("2006-01-02"), " To: ", projectInfo[0].EndDate.Format("2006-01-02"))
				}
			}

			createHeader(pdf, "Project Name: "+nameProject, dates, wTable)

			// Color and font restoration

			pdf.SetFillColor(222, 225, 229)
			pdf.SetTextColor(0, 0, 0)
			pdf.SetFont("", "", 0)

			mapPerRange := GetAvailabilityPerRange(project)
			sameName := false
			for i, ranges := range mapPerRange.ListOfRange {
				//y := 20 * (j + 1)
				pdf.SetX(15)
				if sameName {
					pdf.CellFormat(wTable[0], 0, "", "", 0, "", fill, 0, "")
					if i >= len(mapPerRange.ListOfRange)-1 || mapPerRange.ListOfRange[i+1].ResourceName != ranges.ResourceName {
						sameName = false
					}
				} else {
					if i < len(mapPerRange.ListOfRange)-1 && mapPerRange.ListOfRange[i+1].ResourceName == ranges.ResourceName {
						sameName = true
					}
					if sameName {
						count := 1
						for j := i; j <= len(mapPerRange.ListOfRange); j++ {
							if j < len(mapPerRange.ListOfRange)-1 && mapPerRange.ListOfRange[j].ProjectName == mapPerRange.ListOfRange[j+1].ProjectName {
								count++
							}
						}
						pdf.CellFormat(wTable[0], float64(count*6), ranges.ResourceName, "LR", 0, "", fill, 0, "")
					} else {
						pdf.CellFormat(wTable[0], 6, ranges.ResourceName, "LR", 0, "", fill, 0, "")
					}
				}
				pdf.CellFormat(wTable[1], 6, ranges.StartDate, "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[2], 6, ranges.EndDate, "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[3], 6, strconv.FormatFloat(ranges.Hours, 'f', 1, 64), "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[4], 6, strconv.FormatFloat(ranges.HoursPerDay, 'f', 1, 64), "LR", 0, "C", fill, 0, "")
				pdf.Ln(-1)
				if !sameName || fill {
					fill = !fill
				}
			}
			pdf.SetX(15)
			pdf.CellFormat(wSum, 0, "", "T", 0, "", false, 0, "")
		}
	}

	pdf.SetFont("Arial", "", 14)

	projectTable()

	pdf.OutputFileAndClose("static/pdf/" + filePDF)
	return filePDF
}

func GetAvailabilityPerRange(pProject []*domain.ProjectResources) *domain.ResourceAvailabilityInformation {
	//availBreakdownPerRange := make(map[int]*domain.ResourceAvailabilityInformation)

	resourceAvailabilityInformation := new(domain.ResourceAvailabilityInformation)
	//var totalHours float64
	rangesPerDay := []*domain.RangeDatesAvailability{}
	rangePerDay := new(domain.RangeDatesAvailability)
	totalHours := 0.0
	//lastNumberHours := 0.0

	dao.SortByStartDate(pProject)

	for i, projectResource := range pProject {

		if rangePerDay.StartDate == "" {
			rangePerDay.StartDate = projectResource.StartDate.Format("2006-01-02")
			totalHours += projectResource.Hours
		}
		rangePerDay.EndDate = projectResource.EndDate.Format("2006-01-02")
		if projectResource.Hours > 8 {
			var days float64
			holidays := 0
			for day := projectResource.StartDate; day.Unix() < projectResource.EndDate.AddDate(0, 0, 1).Unix(); day = day.AddDate(0, 0, 1) {
				if day.Weekday() == time.Saturday || day.Weekday() == time.Sunday {
					holidays++
				}
			}
			days = float64(util.CalcularDiasEntreDosFechas(projectResource.StartDate.Unix(), projectResource.EndDate.Unix()))

			rangePerDay.HoursPerDay = projectResource.Hours / (days - float64(holidays) + 1)
		} else {
			rangePerDay.HoursPerDay = projectResource.Hours
		}
		rangePerDay.Hours += projectResource.Hours
		rangePerDay.ResourceName = projectResource.ResourceName
		rangePerDay.ProjectName = projectResource.ProjectName
		if i < len(pProject)-1 {
			nextProjectResource := pProject[i+1]
			if nextProjectResource.ResourceId == projectResource.ResourceId &&
				(nextProjectResource.StartDate.Unix() == util.AgregarORestaDiasAUnaFecha(projectResource.EndDate.Unix(), 1) ||
					((projectResource.EndDate.Weekday() == time.Friday && nextProjectResource.StartDate.Weekday() == time.Monday) && (nextProjectResource.StartDate.Unix() == util.AgregarORestaDiasAUnaFecha(projectResource.EndDate.Unix(), 3)))) &&
				nextProjectResource.Hours == projectResource.Hours {
				totalHours += projectResource.Hours
				continue
			} else {
				rangesPerDay = append(rangesPerDay, rangePerDay)
				resourceAvailabilityInformation.ListOfRange = rangesPerDay
				resourceAvailabilityInformation.TotalHours = totalHours
				//availBreakdownPerRange[projectResource.ResourceId] = resourceAvailabilityInformation

				rangePerDay = new(domain.RangeDatesAvailability)
			}
		} else {
			rangesPerDay = append(rangesPerDay, rangePerDay)
			resourceAvailabilityInformation.ListOfRange = rangesPerDay
			resourceAvailabilityInformation.TotalHours = totalHours

			//availBreakdownPerRange[projectResource.ResourceId] = resourceAvailabilityInformation

			rangePerDay = new(domain.RangeDatesAvailability)
		}
	}

	return resourceAvailabilityInformation
}

func ResourceAssign(pInput domain.GetResourcesToProjectsRQ) string {

	filePDF := "ResourceAssign.pdf"
	deleteFile(filePDF)

	pdf := gofpdf.New("P", "mm", "letter", "")
	resourceToProjects := getResourceAsssign(pInput)
	template := buildTemplate("Resource Assign", pdf)

	wTable := []float64{70, 30, 30, 20, 40}
	wSum := 0.0
	for _, v := range wTable {
		wSum += v
	}

	projectTable := func() {
		pdf.AddPage()
		pdf.UseTemplate(template)
		pdf.SetY(pdf.GetY() + 30)

		for resourceName, project := range resourceToProjects {
			fill := false
			createHeader(pdf, "Resource Name: "+resourceName, "", wTable)

			// Color and font restoration
			pdf.SetFillColor(222, 225, 229)
			pdf.SetTextColor(0, 0, 0)
			pdf.SetFont("", "", 0)
			mapPerRange := GetAvailabilityPerRange(project)
			sameName := false
			for i, ranges := range mapPerRange.ListOfRange {
				pdf.SetX(15)
				if sameName {
					pdf.CellFormat(wTable[0], 0, "", "", 0, "", fill, 0, "")
					if i >= len(mapPerRange.ListOfRange)-1 || mapPerRange.ListOfRange[i+1].ProjectName != ranges.ProjectName {
						sameName = false
					}
				} else {
					if i < len(mapPerRange.ListOfRange)-1 && mapPerRange.ListOfRange[i+1].ProjectName == ranges.ProjectName {
						sameName = true
					}
					if sameName {
						count := 1
						for j := i; j <= len(mapPerRange.ListOfRange); j++ {
							if j < len(mapPerRange.ListOfRange)-1 && mapPerRange.ListOfRange[j].ProjectName == mapPerRange.ListOfRange[j+1].ProjectName {
								count++
							}
						}
						pdf.CellFormat(wTable[0], float64(count*8), ranges.ProjectName, "LR", 0, "", fill, 0, "")
					} else {
						pdf.CellFormat(wTable[0], 8, ranges.ProjectName, "LR", 0, "", fill, 0, "")
					}
				}
				pdf.CellFormat(wTable[1], 8, ranges.StartDate, "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[2], 8, ranges.EndDate, "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[3], 8, strconv.FormatFloat(ranges.Hours, 'f', 1, 64), "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[4], 8, strconv.FormatFloat(ranges.HoursPerDay, 'f', 1, 64), "LR", 0, "C", fill, 0, "")
				pdf.Ln(-1)
				fill = !fill
			}
			pdf.SetX(15)
			pdf.CellFormat(wSum, 0, "", "T", 0, "", false, 0, "")
		}
	}

	pdf.SetFont("Arial", "", 14)
	projectTable()

	pdf.OutputFileAndClose("static/pdf/" + filePDF)
	return filePDF
}

func MatrixOfAssign(pInput domain.GetResourcesToProjectsRQ) string {

	filePDF := "MatrixOfAssign.pdf"
	deleteFile(filePDF)

	pdf := gofpdf.New("P", "mm", "letter", "")
	resources, projects := buildProjectAndResource(pInput)
	template := buildTemplate("Matrix of Assign", pdf)

	wTable := []float64{90, 15, 35, 25}
	wSum := 0.0
	for _, v := range wTable {
		wSum += v
	}

	projectTable := func() {

		pdf.AddPage()
		pdf.UseTemplate(template)
		pdf.SetY(pdf.GetY() + 15)
		createProjectsHeader(pdf, projects, wTable)
		pdf.SetY(pdf.GetY() - 15)

		for _, resourceName := range resources {
			fill := false

			pdf.SetX(15)
			pdf.SetFillColor(222, 225, 229)
			pdf.SetTextColor(0, 0, 0)
			pdf.SetFont("", "", 0)
			pdf.CellFormat(wTable[0], 6, resourceName, "LR", 0, "", fill, 0, "")

			for _, project := range projects {
				hour := float64(0)
				if project[resourceName] != nil {
					hour = project[resourceName].Hours
				}
				pdf.CellFormat(wTable[1], 6, strconv.FormatFloat(hour, 'f', 1, 64), "LR", 0, "C", fill, 0, "")
			}
			pdf.Ln(-1)
		}
	}

	pdf.SetFont("Arial", "", 14)

	projectTable()

	pdf.OutputFileAndClose("static/pdf/" + filePDF)
	return filePDF
}

func createHeader(pdf *gofpdf.Fpdf, pName, pDate string, wTable []float64) {

	pdf.Write(15, "\n")
	pdf.Text(10, pdf.GetY(), pName)
	pdf.Write(5, "\n")
	pdf.SetFont("Arial", "", 10)
	pdf.Text(10, pdf.GetY(), pDate)
	pdf.SetFont("Arial", "", 14)
	pdf.Write(5, "\n")
	pdf.SetX(15)
	header := []string{"Name", "Start Date", "End Date", "Hours", "Hs. per day"}
	// Colors, line width and bold font
	pdf.SetFillColor(47, 67, 80) // 0, 92, 138
	pdf.SetTextColor(255, 255, 255)
	pdf.SetDrawColor(0, 0, 0)
	pdf.SetLineWidth(.3)
	pdf.SetFont("", "B", 0)

	wSum := 0.0
	for _, v := range wTable {
		wSum += v
	}
	for j, str := range header {
		pdf.CellFormat(wTable[j], 6, str, "LR", 0, "C", true, 0, "")
	}
	pdf.Ln(-1)
}

func createProjectsHeader(pdf *gofpdf.Fpdf, projects map[string]map[string]*domain.ProjectResources, wTable []float64) {

	pdf.Write(15, "\n")
	//pdf.Text(10, pdf.GetY(), pName)
	//pdf.Write(5, "\n")
	pdf.SetX(15)
	//	header := []string{"Name", "Start Date", "End Date", "Hours"}
	// Colors, line width and bold font
	pdf.SetFillColor(47, 67, 80) // 0, 92, 138
	pdf.SetTextColor(255, 255, 255)
	pdf.SetDrawColor(0, 0, 0)
	pdf.SetLineWidth(.3)
	pdf.SetFont("", "B", 0)

	wSum := 0.0
	for _, v := range wTable {
		wSum += v
	}

	pdf.CellFormat(90, 50, "Project/Resource", "LR", 0, "C", true, 0, "")

	pdf.SetY(pdf.GetY() + 50)
	pdf.SetX(105)
	for name, _ := range projects {

		pdf.TransformBegin()
		pdf.TransformRotate(90, pdf.GetX(), pdf.GetY())
		//Rotate(90, iniX, 55.00125)
		pdf.CellFormat(50, 15, name, "LR", 0, "M", true, 0, "")
		pdf.SetX(pdf.GetX() - 34.7)
		//pdf.SetY(pdf.GetY() + 15)

		//refDupe()
		pdf.TransformEnd()
	}

	pdf.Ln(-1)
	pdf.SetX(15)

}

func buildTemplate(pName string, pdf *gofpdf.Fpdf) gofpdf.Template {
	template := pdf.CreateTemplate(func(tpl *gofpdf.Tpl) {
		tpl.Image("static/img/prm.png", 10, 6, 0, 0, true, "", 0, "")
		tpl.SetFont("Arial", "B", 16)
		tpl.WriteAligned(0, 0, pName, "C")
		//tpl.Text(80, 20, pName)
		tpl.Ln(-1)
	})
	return template
}

func GetAllProjects(pInput domain.GetProjectsRQ) []*domain.Project {

	inputBuffer := utilr.EncoderInput(pInput)

	operation := "GetProjects"
	res, _ := utilr.PostData(operation, inputBuffer)

	message := new(domain.GetProjectsRS)
	json.NewDecoder(res.Body).Decode(&message)
	return message.Projects
}

func GetAllResources() []*domain.Resource {

	operation := "GetResources"
	res, _ := utilr.PostData(operation, nil)

	message := new(domain.GetResourcesRS)
	json.NewDecoder(res.Body).Decode(&message)
	return message.Resources
}

func getProjectAssign(pInput domain.GetResourcesToProjectsRQ) map[string][]*domain.ProjectResources {

	inputBuffer := utilr.EncoderInput(pInput)

	mapPR := map[string][]*domain.ProjectResources{}
	operation := "GetResourcesToProjects"

	res, _ := utilr.PostData(operation, inputBuffer)

	message := new(domain.GetResourcesToProjectsRS)
	json.NewDecoder(res.Body).Decode(&message)

	for _, rpr := range message.ResourcesToProjects {

		if mapPR[rpr.ProjectName] != nil || len(mapPR[rpr.ProjectName]) > 0 {
			mapPR[rpr.ProjectName] = append(mapPR[rpr.ProjectName], rpr)
		} else {
			pResources := []*domain.ProjectResources{}
			pResources = append(pResources, rpr)
			mapPR[rpr.ProjectName] = pResources
		}
	}
	return mapPR
}

func buildProjectAndResource(pInput domain.GetResourcesToProjectsRQ) (map[int]string, map[string]map[string]*domain.ProjectResources) { //} map[string]float64 {

	inputBuffer := utilr.EncoderInput(pInput)

	operation := "GetResourcesToProjects"
	res, _ := utilr.PostData(operation, inputBuffer)
	message := new(domain.GetResourcesToProjectsRS)
	json.NewDecoder(res.Body).Decode(&message)

	//map[string]*domain.ProjectResources
	/*var mapPR map[string]float64

	for _, rpr := range message.ResourcesToProjects {
		if mapPR == nil {
			mapPR = make(map[string]float64)
		}
		if mapPR[rpr.ProjectName] != 0 {

		}
	}


	return mapPR*/
	var mapPR map[string]map[string]*domain.ProjectResources
	mapResources := map[int]string{}

	mapPR = make(map[string]map[string]*domain.ProjectResources)
	//mapInternal := make(map[string]*domain.ProjectResources)

	for _, rpr := range message.ResourcesToProjects {

		if mapPR[rpr.ProjectName] == nil {
			mapPR[rpr.ProjectName] = make(map[string]*domain.ProjectResources)
		}
		if len(mapPR[rpr.ProjectName]) > 0 {
			if mapPR[rpr.ProjectName][rpr.ResourceName] == nil {
				mapPR[rpr.ProjectName][rpr.ResourceName] = new(domain.ProjectResources)
				mapPR[rpr.ProjectName][rpr.ResourceName] = rpr
			} else {
				mapPR[rpr.ProjectName][rpr.ResourceName].Hours = mapPR[rpr.ProjectName][rpr.ResourceName].Hours + rpr.Hours
			}
		} else {
			pResources := map[string]*domain.ProjectResources{}
			pResources[rpr.ResourceName] = rpr
			mapPR[rpr.ProjectName] = pResources
		}
		if mapResources[rpr.ResourceId] == "" {
			mapResources[rpr.ResourceId] = rpr.ResourceName
		}

	}
	return mapResources, mapPR
}

func getResourceAsssign(pInput domain.GetResourcesToProjectsRQ) map[string][]*domain.ProjectResources {

	inputBuffer := utilr.EncoderInput(pInput)

	mapPR := map[string][]*domain.ProjectResources{}
	operation := "GetResourcesToProjects"

	res, _ := utilr.PostData(operation, inputBuffer)

	message := new(domain.GetResourcesToProjectsRS)
	json.NewDecoder(res.Body).Decode(&message)

	for _, rpr := range message.ResourcesToProjects {

		if mapPR[rpr.ResourceName] != nil || len(mapPR[rpr.ResourceName]) > 0 {
			mapPR[rpr.ResourceName] = append(mapPR[rpr.ResourceName], rpr)
		} else {
			pResources := []*domain.ProjectResources{}
			pResources = append(pResources, rpr)
			mapPR[rpr.ResourceName] = pResources
		}
	}
	return mapPR
}

// Function that create folder if not exist
func createFolder() {
	_, err := os.Stat("static/pdf")
	if os.IsNotExist(err) {
		os.Mkdir("static/pdf", os.ModePerm)
	}
}

// function that delete the file to generate.
func deleteFile(pFilePDF string) {
	_, err := os.Stat("static/pdf/" + pFilePDF)
	if !os.IsNotExist(err) {
		os.Remove("static/pdf/" + pFilePDF)
	}
}
