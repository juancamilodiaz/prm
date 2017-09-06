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
	beego.Router("/resources", &controllers.MainController{}, "post:ListResources")
	beego.Router("/resources/create", &controllers.MainController{}, "post:CreateResource")
	beego.Router("/resources/update", &controllers.MainController{}, "post:UpdateResource")
	beego.Router("/resources/delete", &controllers.MainController{}, "post:DeleteResource")
}
