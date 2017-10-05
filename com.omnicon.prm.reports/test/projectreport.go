package test

import (
	"strconv"

	"encoding/json"

	"github.com/jung-kurt/gofpdf"
	utilr "prm/com.omnicon.prm.reports/util"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/util"
)

/*
func main() {
	//createTemplate()
	//listProjects()
	//listProjects2()
	listProjects3()
}*/

func listProjects() {
	pdf := gofpdf.New("P", "mm", "A4", "")

	header := []string{"Name", "Start Date", "End Date", "Active"}

	projects := getAllProjects()

	basicTable := func() {
		for _, str := range header {
			pdf.CellFormat(40, 7, str, "1", 0, "", false, 0, "")
		}
		pdf.Ln(-1)
		for _, p := range projects {
			pdf.CellFormat(40, 6, p.Name, "1", 0, "", false, 0, "")
			pdf.CellFormat(40, 6, util.GetFechaConFormato(p.StartDate.Unix(), util.DATEFORMAT), "1", 0, "", false, 0, "")
			pdf.CellFormat(40, 6, util.GetFechaConFormato(p.EndDate.Unix(), util.DATEFORMAT), "1", 0, "", false, 0, "")
			pdf.CellFormat(40, 6, strconv.FormatBool(p.Enabled), "1", 0, "", false, 0, "")
			pdf.Ln(-1)
		}
	}

	pdf.SetFont("Arial", "", 14)
	pdf.AddPage()
	basicTable()
	pdf.AddPage()

	pdf.OutputFileAndClose("projects1.pdf")
}

func listProjects2() {
	pdf := gofpdf.New("P", "mm", "A4", "")

	header := []string{"Name", "Start Date", "End Date", "Active"}

	projects := getAllProjects()

	fancyTable := func() {
		// Colors, line width and bold font
		pdf.SetFillColor(0, 0, 255)
		pdf.SetTextColor(255, 255, 255)
		pdf.SetDrawColor(0, 0, 0)
		pdf.SetLineWidth(.3)
		pdf.SetFont("", "B", 0)
		w := []float64{45, 30, 30, 20}
		wSum := 0.0
		for _, v := range w {
			wSum += v
		}

		for j, str := range header {
			pdf.CellFormat(w[j], 7, str, "1", 0, "C", true, 0, "")
		}
		pdf.Ln(-1)
		// Color and font restoration
		pdf.SetFillColor(224, 235, 255)
		pdf.SetTextColor(0, 0, 0)
		pdf.SetFont("", "", 0)
		// 	Data
		fill := false
		for _, p := range projects {
			pdf.CellFormat(w[0], 6, p.Name, "LR", 0, "", fill, 0, "")
			pdf.CellFormat(w[1], 6, util.GetFechaConFormato(p.StartDate.Unix(), util.DATEFORMAT), "LR", 0, "", fill, 0, "")
			pdf.CellFormat(w[2], 6, util.GetFechaConFormato(p.EndDate.Unix(), util.DATEFORMAT), "LR", 0, "", fill, 0, "")
			pdf.CellFormat(w[3], 6, strconv.FormatBool(p.Enabled), "LR", 0, "R", fill, 0, "")
			pdf.Ln(-1)
			fill = !fill
		}
		pdf.CellFormat(wSum, 0, "", "T", 0, "", false, 0, "")
	}

	pdf.SetFont("Arial", "", 14)

	pdf.AddPage()
	pdf.Text(80, 10, "Projects")
	pdf.Write(10, "\n")
	fancyTable()
	pdf.AddPage()

	pdf.OutputFileAndClose("projects2.pdf")
}

func createTemplate() {
	pdf := gofpdf.New("P", "mm", "A4", "")

	template := pdf.CreateTemplate(func(tpl *gofpdf.Tpl) {
		//tpl.Image(example.ImageFile("logo.png"), 6, 6, 30, 0, false, "", 0, "")
		tpl.SetFont("Arial", "B", 16)
		tpl.Text(40, 20, "Projects")
		tpl.SetDrawColor(0, 100, 200)
		tpl.SetLineWidth(2.5)
		tpl.Line(95, 12, 105, 22)
	})
	//	_, tplSize := template.Size()

	pdf.SetDrawColor(200, 100, 0)
	pdf.SetLineWidth(2.5)
	pdf.SetFont("Arial", "B", 16)
	pdf.AddPage()
	pdf.UseTemplate(template)

	//pdf.Line(40, 210, 60, 210)
	pdf.Text(40, 200, "Template example page 1")
	pdf.OutputFileAndClose("projects3.pdf")

}

func ProjectAssign() string {
	pdf := gofpdf.New("P", "mm", "A4", "")

	resourceToProjects := getResourceToProject()
	w := []float64{45, 30, 30, 20}

	projectTable := func() {

		for nameProject, project := range resourceToProjects {
			fill := false

			pdf.Text(80, 10, nameProject)
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
			pdf.AddPage()
		}
		//pdf.CellFormat(wSum, 0, "", "T", 0, "", false, 0, "")
	}

	pdf.SetFont("Arial", "", 14)

	pdf.AddPage()
	projectTable()

	filePDF := "ProjectAssign.pdf"
	pdf.OutputFileAndClose(filePDF)
	return filePDF
}

func ResourceAssign() string {
	pdf := gofpdf.New("P", "mm", "A4", "")

	resourceToProjects := getResourceToProject()
	w := []float64{45, 30, 30, 20}

	projectTable := func() {

		for nameProject, project := range resourceToProjects {
			fill := false

			pdf.Text(80, 10, nameProject)
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
			pdf.AddPage()
		}
		//pdf.CellFormat(wSum, 0, "", "T", 0, "", false, 0, "")
	}

	pdf.SetFont("Arial", "", 14)

	pdf.AddPage()
	projectTable()

	filePDF := "projects2.pdf"
	pdf.OutputFileAndClose(filePDF)
	return filePDF
}

func createHeader(pdf *gofpdf.Fpdf) {
	header := []string{"Name", "Start Date", "End Date", "Hours"}
	// Colors, line width and bold font
	pdf.SetFillColor(0, 0, 255)
	pdf.SetTextColor(255, 255, 255)
	pdf.SetDrawColor(0, 0, 0)
	pdf.SetLineWidth(.3)
	pdf.SetFont("", "B", 0)
	w := []float64{45, 30, 30, 20}
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

func getResourceToProject() map[string][]*domain.ProjectResources {
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
