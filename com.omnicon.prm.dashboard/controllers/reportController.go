package controllers

import (
	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.reports/report"
	"prm/com.omnicon.prm.service/domain"
)

type ReportController struct {
	beego.Controller
}

/*Index*/
func (this *ReportController) Reports() {
	this.Data["PDF"] = ""
	this.Data["Projects"] = report.GetAllProjects()
	this.Data["Resources"] = report.GetAllResources()
	this.TplName = "Reports/reports.tpl"
}

func (this *ReportController) ProjectAssign() {
	input := domain.GetResourcesToProjectsRQ{}
	this.ParseForm(&input)
	fileName := report.ProjectAssign(input)
	this.Data["PDF"] = "/static/pdf/" + fileName
	this.TplName = "Reports/report.tpl"
}

func (this *ReportController) ResourceAssign() {
	input := domain.GetResourcesToProjectsRQ{}
	this.ParseForm(&input)
	fileName := report.ResourceAssign(input)
	this.Data["PDF"] = "/static/pdf/" + fileName
	this.TplName = "Reports/report.tpl"
}

func (this *ReportController) MatrixOfAssign() {
	input := domain.GetResourcesToProjectsRQ{}
	this.ParseForm(&input)
	fileName := report.MatrixOfAssign(input)
	this.Data["PDF"] = "/static/pdf/" + fileName
	this.TplName = "Reports/report.tpl"
}
