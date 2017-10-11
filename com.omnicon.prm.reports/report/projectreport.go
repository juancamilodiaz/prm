package report

import (
	"strconv"

	"encoding/json"

	"os"

	"github.com/jung-kurt/gofpdf"
	utilr "prm/com.omnicon.prm.reports/util"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/util"
)

func ProjectAssign() string {
	pdf := gofpdf.New("P", "mm", "letter", "")

	resourceToProjects := getProjectAssign()
	template := buildTemplate("Project Assign", pdf)

	wTable := []float64{90, 35, 35, 25}
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

			createHeader(pdf, "Project Name: "+nameProject, wTable)

			// Color and font restoration

			pdf.SetFillColor(222, 225, 229)
			pdf.SetTextColor(0, 0, 0)
			pdf.SetFont("", "", 0)
			for _, resources := range project {
				//y := 20 * (j + 1)
				pdf.SetX(15)
				pdf.CellFormat(wTable[0], 6, resources.ResourceName, "LR", 0, "", fill, 0, "")
				pdf.CellFormat(wTable[1], 6, util.GetFechaConFormato(resources.StartDate.Unix(), util.DATEFORMAT), "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[2], 6, util.GetFechaConFormato(resources.EndDate.Unix(), util.DATEFORMAT), "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[3], 6, strconv.FormatFloat(resources.Hours, 'f', 1, 64), "LR", 0, "C", fill, 0, "")
				pdf.Ln(-1)
				fill = !fill
			}
			pdf.SetX(15)
			pdf.CellFormat(wSum, 0, "", "T", 0, "", false, 0, "")
		}
	}

	pdf.SetFont("Arial", "", 14)

	projectTable()

	filePDF := "ProjectAssign.pdf"
	_, err := os.Stat("static/pdf")
	if os.IsNotExist(err) {
		os.Mkdir("static/pdf", os.ModePerm)
	}
	pdf.OutputFileAndClose("static/pdf/" + filePDF)
	return filePDF
}

func ResourceAssign() string {
	pdf := gofpdf.New("P", "mm", "letter", "")
	resourceToProjects := getResourceAsssign()
	template := buildTemplate("Resource Assign", pdf)

	wTable := []float64{90, 35, 35, 25}
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
			createHeader(pdf, "Resource Name: "+resourceName, wTable)

			// Color and font restoration
			pdf.SetFillColor(222, 225, 229)
			pdf.SetTextColor(0, 0, 0)
			pdf.SetFont("", "", 0)
			for _, resources := range project {
				pdf.SetX(15)
				pdf.CellFormat(wTable[0], 8, resources.ProjectName, "LR", 0, "", fill, 0, "")
				pdf.CellFormat(wTable[1], 8, util.GetFechaConFormato(resources.StartDate.Unix(), util.DATEFORMAT), "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[2], 8, util.GetFechaConFormato(resources.EndDate.Unix(), util.DATEFORMAT), "LR", 0, "C", fill, 0, "")
				pdf.CellFormat(wTable[3], 8, strconv.FormatFloat(resources.Hours, 'f', 1, 64), "LR", 0, "C", fill, 0, "")
				pdf.Ln(-1)
				fill = !fill
			}
			pdf.SetX(15)
			pdf.CellFormat(wSum, 0, "", "T", 0, "", false, 0, "")
		}
	}

	pdf.SetFont("Arial", "", 14)
	projectTable()

	filePDF := "ResourceAssign.pdf"
	pdf.OutputFileAndClose("static/pdf/" + filePDF)
	return filePDF
}

func MatrixOfAssign() string {
	pdf := gofpdf.New("P", "mm", "letter", "")
	resources, projects := buildProjectAndResource()
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

	filePDF := "MatrixOfAssign.pdf"
	_, err := os.Stat("static/pdf")
	if os.IsNotExist(err) {
		os.Mkdir("static/pdf", os.ModePerm)
	}

	pdf.OutputFileAndClose("static/pdf/" + filePDF)
	return filePDF
}

func createHeader(pdf *gofpdf.Fpdf, pName string, wTable []float64) {

	pdf.Write(15, "\n")
	pdf.Text(10, pdf.GetY(), pName)
	pdf.Write(5, "\n")
	pdf.SetX(15)
	header := []string{"Name", "Start Date", "End Date", "Hours"}
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
		tpl.Text(80, 20, pName)
		tpl.Ln(-1)
	})
	return template
}

func getAllProjects() []*domain.Project {
	operation := "GetProjects"
	res, _ := utilr.PostData(operation, nil)

	message := new(domain.GetProjectsRS)
	json.NewDecoder(res.Body).Decode(&message)
	return message.Projects
}

func getProjectAssign() map[string][]*domain.ProjectResources {
	mapPR := map[string][]*domain.ProjectResources{}
	operation := "GetResourcesToProjects"

	res, _ := utilr.PostData(operation, nil)

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

func buildProjectAndResource() (map[int64]string, map[string]map[string]*domain.ProjectResources) { //} map[string]float64 {
	operation := "GetResourcesToProjects"
	res, _ := utilr.PostData(operation, nil)
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
	mapResources := map[int64]string{}

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

func getResourceAsssign() map[string][]*domain.ProjectResources {
	mapPR := map[string][]*domain.ProjectResources{}
	operation := "GetResourcesToProjects"

	res, _ := utilr.PostData(operation, nil)

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
