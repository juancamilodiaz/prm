package controllers

import (
	//"encoding/json"
	//	"io/ioutil"

	"github.com/astaxie/beego"
	//"prm/com.omnicon.prm.service/domain"
	//"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.reports/report"
)

type ReportController struct {
	beego.Controller
}

/*Index*/
func (this *ReportController) Reports() {
	this.Data["PDF"] = ""
	this.TplName = "Reports/reports.tpl"
}

func (this *ReportController) ProjectAssign() {
	fileName := report.ProjectAssign()
	this.Data["PDF"] = "/static/pdf/" + fileName
	this.TplName = "Reports/report.tpl"
}

func (this *ReportController) ResourceAssign() {
	fileName := report.ResourceAssign()
	this.Data["PDF"] = "/static/pdf/" + fileName
	this.TplName = "Reports/report.tpl"
}
