package routers

import (
	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.dashboard/controllers"
)

func init() {
	beego.SetStaticPath("/css", "static/css")
	beego.SetStaticPath("/js", "static/js")
	beego.SetStaticPath("/img", "static/img")
	beego.Router("/", &controllers.MainController{})

	// Resources
	beego.Router("/resources", &controllers.ResourceController{}, "post:ListResources")
	beego.Router("/resources/create", &controllers.ResourceController{}, "post:CreateResource")
	beego.Router("/resources/read", &controllers.ResourceController{}, "post:ReadResource")
	beego.Router("/resources/update", &controllers.ResourceController{}, "post:UpdateResource")
	beego.Router("/resources/delete", &controllers.ResourceController{}, "post:DeleteResource")
	beego.Router("/resources/skills", &controllers.ResourceController{}, "post:GetSkillsByResource")
	// Projects
	beego.Router("/projects", &controllers.ProjectController{}, "post:ListProjects")
	beego.Router("/projects/create", &controllers.ProjectController{}, "post:CreateProject")
	beego.Router("/projects/read", &controllers.ProjectController{}, "post:ReadProject")
	beego.Router("/projects/update", &controllers.ProjectController{}, "post:UpdateProject")
	beego.Router("/projects/delete", &controllers.ProjectController{}, "post:DeleteProject")
	beego.Router("/projects/resources", &controllers.ProjectController{}, "post:GetResourcesByProject")
	beego.Router("/projects/resources/unassign", &controllers.ProjectController{}, "post:DeleteResourceToProject")
	beego.Router("/projects/resources/today", &controllers.ProjectController{}, "post:GetResourcesByProjectToday")
	// Skills
	beego.Router("/skills", &controllers.SkillController{}, "post:ListSkills")
	beego.Router("/skills/create", &controllers.SkillController{}, "post:CreateSkill")
	beego.Router("/skills/read", &controllers.SkillController{}, "post:ReadSkill")
	beego.Router("/skills/update", &controllers.SkillController{}, "post:UpdateSkill")
	beego.Router("/skills/delete", &controllers.SkillController{}, "post:DeleteSkill")

}
