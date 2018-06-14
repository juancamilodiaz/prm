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
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= au {
			this.Data["PDF"] = ""
			this.Data["Projects"] = report.GetAllProjects(domain.GetProjectsRQ{})
			this.Data["Resources"] = report.GetAllResources()
			this.TplName = "Reports/reports.tpl"
		} else if level > au {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ReportController) ProjectAssign() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			input := domain.GetResourcesToProjectsRQ{}
			this.ParseForm(&input)
			fileName := report.ProjectAssign(input)
			this.Data["PDF"] = "/static/pdf/" + fileName
			this.TplName = "Reports/report.tpl"
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ReportController) ResourceAssign() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			input := domain.GetResourcesToProjectsRQ{}
			this.ParseForm(&input)
			fileName := report.ResourceAssign(input)
			this.Data["PDF"] = "/static/pdf/" + fileName
			this.TplName = "Reports/report.tpl"
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}

func (this *ReportController) MatrixOfAssign() {
	if session != nil {
		level := authorizeLevel(session.Email, superusers, adminusers, planusers, trainerusers)

		if level <= pu {
			input := domain.GetResourcesToProjectsRQ{}
			this.ParseForm(&input)
			fileName := report.MatrixOfAssign(input)
			this.Data["PDF"] = "/static/pdf/" + fileName
			this.TplName = "Reports/report.tpl"
		} else if level > pu {
			this.Data["Title"] = "You don't have enough permissions."
			this.Data["Message"] = "Please contact with the system manager."
			this.Data["Type"] = "Error"
			this.TplName = "Common/message.tpl"
		}
	}
}
