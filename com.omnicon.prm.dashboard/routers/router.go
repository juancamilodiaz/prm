package routers

import (
	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.dashboard/controllers"
)

func init() {
	beego.SetStaticPath("/oauth2/css", "static/css")
	beego.SetStaticPath("/oauth2/js", "static/js")
	beego.SetStaticPath("/oauth2/img", "static/img")
	beego.SetStaticPath("/oauth2/pdf", "static/pdf")

	beego.Router("/callback", &controllers.AzureController{})

	beego.Router("/", &controllers.MainController{})
	beego.Router("/about", &controllers.AboutController{}, "post:About")

	beego.Router("/start/", &controllers.AzureController{})

	beego.Router("/oauth2/", &controllers.AzureController{})
	beego.Router("/oauth2/callback", &controllers.AzureController{}, "get:Callback")
	//beego.Router("/azure/", &controllers.AzureController{})
	//beego.Router("/azure/authorize", &controllers.AzureController{}, "post:Authorize")
	//beego.Router("/oauth2/callback", &controllers.AzureController{}, "post:Callback")

	// Resources
	beego.Router("/resources", &controllers.ResourceController{}, "post:ListResources")
	beego.Router("/resources/create", &controllers.ResourceController{}, "post:CreateResource")
	beego.Router("/resources/read", &controllers.ResourceController{}, "post:ReadResource")
	beego.Router("/resources/update", &controllers.ResourceController{}, "post:UpdateResource")
	beego.Router("/resources/delete", &controllers.ResourceController{}, "post:DeleteResource")
	beego.Router("/resources/skills", &controllers.ResourceController{}, "post:GetSkillsByResource")
	beego.Router("/resources/setskill", &controllers.ResourceController{}, "post:SetSkillsToResource")
	beego.Router("/resources/deleteskill", &controllers.ResourceController{}, "post:DeleteSkillsToResource")
	beego.Router("/resources/types", &controllers.ResourceController{}, "post:GetTypesByResource")
	beego.Router("/resources/allAssigments", &controllers.ResourceController{}, "post:ReadResourcePlanning")
	beego.Router("/resources/types/unassign", &controllers.ResourceController{}, "post:DeleteTypesByResource")
	beego.Router("/resources/settype", &controllers.ResourceController{}, "post:SetTypesToResource")
	// Forecast Projects
	beego.Router("/projectsForecast", &controllers.ProjectForecastController{}, "post:ListProjectsForecast")
	beego.Router("/projectsForecast/create", &controllers.ProjectForecastController{}, "post:CreateProjectForecast")
	beego.Router("/projectsForecast/update", &controllers.ProjectForecastController{}, "post:UpdateProjectForecast")
	beego.Router("/projectsForecast/delete", &controllers.ProjectForecastController{}, "post:DeleteProjectForecast")
	// Projects
	beego.Router("/projects", &controllers.ProjectController{}, "post:ListProjects")
	beego.Router("/projects/create", &controllers.ProjectController{}, "post:CreateProject")
	beego.Router("/projects/read", &controllers.ProjectController{}, "post:ReadProject")
	beego.Router("/projects/update", &controllers.ProjectController{}, "post:UpdateProject")
	beego.Router("/projects/delete", &controllers.ProjectController{}, "post:DeleteProject")
	beego.Router("/projects/resources", &controllers.ProjectController{}, "post:GetResourcesByProject")
	beego.Router("/projects/resources/assignation", &controllers.ProjectController{}, "post:GetAssignationByResource")
	beego.Router("/projects/resources/ownAssignation", &controllers.ProjectController{}, "post:GetOwnAssignation")
	beego.Router("/projects/resources/unassign", &controllers.ProjectController{}, "post:DeleteResourceToProject")
	beego.Router("/projects/setresource", &controllers.ProjectController{}, "post:SetResourceToProject")
	beego.Router("/projects/resources/today", &controllers.ProjectController{}, "post:GetResourcesByProjectToday")
	beego.Router("/projects/recommendation", &controllers.ProjectController{}, "post:GetRecommendationResourcesByProject")
	beego.Router("/projects/types", &controllers.ProjectController{}, "post:GetTypesByProject")
	beego.Router("/projects/types/unassign", &controllers.ProjectController{}, "post:DeleteTypesByProject")
	beego.Router("/projects/settype", &controllers.ProjectController{}, "post:SetTypesToProject")
	beego.Router("/dashboard", &controllers.ProjectController{}, "get,post:Availability")
	beego.Router("/dashboard/availablehours", &controllers.ProjectController{}, "post:AvailabileHours")

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
	beego.Router("/trainings", &controllers.TrainingController{}, "post:ListTrainings")
	beego.Router("/trainings/create", &controllers.TrainingController{}, "post:CreateTraining")
	beego.Router("/trainings/update", &controllers.TrainingController{}, "post:UpdateTraining")
	beego.Router("/trainings/delete", &controllers.TrainingController{}, "post:DeleteTraining")
	beego.Router("/trainings/settraining", &controllers.TrainingController{}, "post:SetTrainingToResource")
	beego.Router("/trainings/resources", &controllers.TrainingController{}, "post:GetTrainingResources")
	beego.Router("/trainings/deletetraining", &controllers.TrainingController{}, "post:DeleteTrainingToResource")

	// Settings
	beego.Router("/settings", &controllers.SettingsController{}, "post:ListSettings")
	beego.Router("/settings/update", &controllers.SettingsController{}, "post:UpdateSettings")

	// Report productivity
	beego.Router("/productivity", &controllers.ProductivityController{}, "post:ListProductivity")
	beego.Router("/productivity/createtask", &controllers.ProductivityController{}, "post:CreateTask")
	beego.Router("/productivity/updatetask", &controllers.ProductivityController{}, "post:UpdateTask")
	beego.Router("/productivity/deletetask", &controllers.ProductivityController{}, "post:DeleteTask")
	beego.Router("/productivity/createreport", &controllers.ProductivityController{}, "post:CreateReport")
	beego.Router("/productivity/updatereport", &controllers.ProductivityController{}, "post:UpdateReport")
	beego.Router("/productivity/deletereport", &controllers.ProductivityController{}, "post:DeleteReport")
}
