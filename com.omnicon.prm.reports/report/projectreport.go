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
	w := []float64{80, 30, 30, 20}

	projectTable := func() {

		pdf.AddPage()

		for nameProject, project := range resourceToProjects {
			fill := false

			pdf.Write(10, "\n")
			pdf.Text(100, pdf.GetY(), nameProject)
			pdf.Write(10, "\n")

			createHeader(pdf)

			// Color and font restoration
			pdf.SetFillColor(224, 235, 255)
			pdf.SetTextColor(0, 0, 0)
			pdf.SetFont("", "", 0)
			for _, resources := range project {
				//y := 20 * (j + 1)
				pdf.CellFormat(w[0], 6, resources.ResourceName, "LR", 0, "", fill, 0, "")
				pdf.CellFormat(w[1], 6, util.GetFechaConFormato(resources.StartDate.Unix(), util.DATEFORMAT), "LR", 0, "", fill, 0, "")
				pdf.CellFormat(w[2], 6, util.GetFechaConFormato(resources.EndDate.Unix(), util.DATEFORMAT), "LR", 0, "", fill, 0, "")
				pdf.CellFormat(w[3], 6, strconv.FormatFloat(resources.Hours, 'f', 1, 64), "LR", 0, "", fill, 0, "")
				pdf.Ln(-1)
				fill = !fill
			}
		}
		//pdf.CellFormat(wSum, 0, "", "T", 0, "", false, 0, "")
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
	w := []float64{80, 30, 30, 20}

	projectTable := func() {

		pdf.AddPage()

		for resourceName, project := range resourceToProjects {
			fill := false

			pdf.Write(10, "\n")
			pdf.Text(100, pdf.GetY(), resourceName)
			pdf.Write(10, "\n")

			createHeader(pdf)

			// Color and font restoration
			pdf.SetFillColor(224, 235, 255)
			pdf.SetTextColor(0, 0, 0)
			pdf.SetFont("", "", 0)
			for _, resources := range project {
				//y := 20 * (j + 1)
				pdf.CellFormat(w[0], 6, resources.ProjectName, "LR", 0, "", fill, 0, "")
				pdf.CellFormat(w[1], 6, util.GetFechaConFormato(resources.StartDate.Unix(), util.DATEFORMAT), "LR", 0, "", fill, 0, "")
				pdf.CellFormat(w[2], 6, util.GetFechaConFormato(resources.EndDate.Unix(), util.DATEFORMAT), "LR", 0, "", fill, 0, "")
				pdf.CellFormat(w[3], 6, strconv.FormatFloat(resources.Hours, 'f', 1, 64), "LR", 0, "", fill, 0, "")
				pdf.Ln(-1)
				fill = !fill
			}

		}
		//pdf.CellFormat(wSum, 0, "", "T", 0, "", false, 0, "")
	}

	pdf.SetFont("Arial", "", 14)

	projectTable()

	filePDF := "ResourceAssign.pdf"
	pdf.OutputFileAndClose("static/pdf/" + filePDF)
	return filePDF
}

func createHeader(pdf *gofpdf.Fpdf) {
	header := []string{"Name", "Start Date", "End Date", "Hours"}
	// Colors, line width and bold font
	pdf.SetFillColor(47, 67, 80) // 0, 92, 138
	pdf.SetTextColor(255, 255, 255)
	pdf.SetDrawColor(0, 0, 0)
	pdf.SetLineWidth(.3)
	pdf.SetFont("", "B", 0)
	w := []float64{80, 30, 30, 20}
	wSum := 0.0
	for _, v := range w {
		wSum += v
	}
	for j, str := range header {
		pdf.CellFormat(w[j], 6, str, "LR", 0, "", true, 0, "")
	}
	pdf.Ln(-1)
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
