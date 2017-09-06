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
	beego.Router("/resources", &controllers.MainController{}, "post:ListResources")
	beego.Router("/resources/create", &controllers.MainController{}, "post:CreateResource")
	beego.Router("/resources/read", &controllers.MainController{}, "post:ReadResource")
	beego.Router("/resources/update", &controllers.MainController{}, "post:UpdateResource")
	beego.Router("/resources/delete", &controllers.MainController{}, "post:DeleteResource")
	// Projects
	beego.Router("/projects", &controllers.MainController{}, "post:ListProjects")
	beego.Router("/projects/create", &controllers.MainController{}, "post:CreateProject")
	beego.Router("/projects/read", &controllers.MainController{}, "post:ReadProject")
	beego.Router("/projects/update", &controllers.MainController{}, "post:UpdateProject")
	beego.Router("/projects/delete", &controllers.MainController{}, "post:DeleteProject")
}
