package controllers

import (
	"github.com/astaxie/beego"
)

type MainController struct {
	beego.Controller
}

/*Index*/
func (c *MainController) Get() {
	c.Data["Website"] = "beego.me"
	c.Data["Email"] = "astaxie@gmail.com"
	c.TplName = "index.tpl"
}

type AboutController struct {
	beego.Controller
}

func (this *AboutController) About() {

	this.TplName = "about.tpl"
	this.TplName = "Resources/resourceform.tpl"
}
