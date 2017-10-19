package routers

import (
	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.dashboard/controllers"
)

func init() {
	beego.SetStaticPath("/css", "static/css")
	beego.SetStaticPath("/js", "static/js")
	beego.SetStaticPath("/img", "static/img")
	beego.SetStaticPath("/pdf", "static/pdf")
	beego.Router("/", &controllers.MainController{})
	beego.Router("/about", &controllers.AboutController{}, "post:About")

	// Resources
	beego.Router("/resources", &controllers.ResourceController{}, "post:ListResources")
	beego.Router("/resources/create", &controllers.ResourceController{}, "post:CreateResource")
	beego.Router("/resources/read", &controllers.ResourceController{}, "post:ReadResource")
	beego.Router("/resources/update", &controllers.ResourceController{}, "post:UpdateResource")
	beego.Router("/resources/delete", &controllers.ResourceController{}, "post:DeleteResource")
	beego.Router("/resources/skills", &controllers.ResourceController{}, "post:GetSkillsByResource")
	beego.Router("/resources/setskill", &controllers.ResourceController{}, "post:SetSkillsToResource")
	beego.Router("/resources/deleteskill", &controllers.ResourceController{}, "post:DeleteSkillsToResource")
	// Projects
	beego.Router("/projects", &controllers.ProjectController{}, "post:ListProjects")
	beego.Router("/projects/create", &controllers.ProjectController{}, "post:CreateProject")
	beego.Router("/projects/read", &controllers.ProjectController{}, "post:ReadProject")
	beego.Router("/projects/update", &controllers.ProjectController{}, "post:UpdateProject")
	beego.Router("/projects/delete", &controllers.ProjectController{}, "post:DeleteProject")
	beego.Router("/projects/resources", &controllers.ProjectController{}, "post:GetResourcesByProject")
	beego.Router("/projects/resources/assignation", &controllers.ProjectController{}, "post:GetAssignationByResource")
	beego.Router("/projects/resources/unassign", &controllers.ProjectController{}, "post:DeleteResourceToProject")
	beego.Router("/projects/setresource", &controllers.ProjectController{}, "post:SetResourceToProject")
	beego.Router("/projects/resources/today", &controllers.ProjectController{}, "post:GetResourcesByProjectToday")
	beego.Router("/projects/recommendation", &controllers.ProjectController{}, "post:GetRecommendationResourcesByProject")
	beego.Router("/projects/types", &controllers.ProjectController{}, "post:GetTypesByProject")
	beego.Router("/projects/types/unassign", &controllers.ProjectController{}, "post:DeleteTypesByProject")
	beego.Router("/projects/settype", &controllers.ProjectController{}, "post:SetTypesToProject")
	beego.Router("/dashboard", &controllers.ProjectController{}, "get,post:Availability")

	// Skills
	beego.Router("/skills", &controllers.SkillController{}, "post:ListSkills")
	beego.Router("/skills/create", &controllers.SkillController{}, "post:CreateSkill")
	beego.Router("/skills/read", &controllers.SkillController{}, "post:ReadSkill")
	beego.Router("/skills/update", &controllers.SkillController{}, "post:UpdateSkill")
	beego.Router("/skills/delete", &controllers.SkillController{}, "post:DeleteSkill")

	beego.Router("/login", &controllers.LoginController{}, "get,post:Login")
	beego.Router("/logout", &controllers.LoginController{}, "get:Logout")
	beego.Router("/signup", &controllers.LoginController{}, "get,post:Signup")
	beego.Router("/passwordreset", &controllers.LoginController{}, "get,post:PasswordReset")
	beego.Router("/changepassword", &controllers.LoginController{}, "get,post:ChangePassword")
	beego.Router("/grantAccess", &controllers.LoginController{}, "get,post:GrantAccess")

	//Types
	beego.Router("/types", &controllers.TypeController{}, "post:ListTypes")
	beego.Router("/types/create", &controllers.TypeController{}, "post:CreateType")
	beego.Router("/types/update", &controllers.TypeController{}, "post:UpdateType")
	beego.Router("/types/delete", &controllers.TypeController{}, "post:DeleteType")
	beego.Router("/types/skills", &controllers.TypeController{}, "post:GetSkillsByType")
	beego.Router("/types/skills/unassign", &controllers.TypeController{}, "post:DeleteSkillsByType")
	beego.Router("/types/setskill", &controllers.TypeController{}, "post:SetSkillToType")

	beego.Router("/reports", &controllers.ReportController{}, "post:Reports")
	beego.Router("/reports/projectassign", &controllers.ReportController{}, "post:ProjectAssign")
	beego.Router("/reports/resourceassign", &controllers.ReportController{}, "post:ResourceAssign")

	//training
	beego.Router("/training", &controllers.TrainingController{}, "post:GetTraining")
}
