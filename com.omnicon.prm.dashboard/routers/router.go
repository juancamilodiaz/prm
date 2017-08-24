package routers

import (
	"prm/com.omnicon.prm.dashboard/controllers"
	"github.com/astaxie/beego"
)

func init() {
    beego.Router("/", &controllers.MainController{})
}
