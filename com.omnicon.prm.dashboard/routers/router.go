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
	// Projects
	beego.Router("/projects", &controllers.MainController{}, "post:ListProjects")
	beego.Router("/projects/create", &controllers.MainController{}, "post:CreateProject")
	beego.Router("/projects/read", &controllers.MainController{}, "post:ReadProject")
	beego.Router("/projects/update", &controllers.MainController{}, "post:UpdateProject")
	beego.Router("/projects/delete", &controllers.MainController{}, "post:DeleteProject")
	// Skills
	beego.Router("/skills", &controllers.MainController{}, "post:ListSkills")
	beego.Router("/skills/create", &controllers.MainController{}, "post:CreateSkill")
	beego.Router("/skills/read", &controllers.MainController{}, "post:ReadSkill")
	beego.Router("/skills/update", &controllers.MainController{}, "post:UpdateSkill")
	beego.Router("/skills/delete", &controllers.MainController{}, "post:DeleteSkill")
}
