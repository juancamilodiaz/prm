package controllers

import (
	"github.com/astaxie/beego"
)

type MainController struct {
	BaseController
}

func (c *MainController) NestPrepare() {
	if !c.IsLogin {
		c.Ctx.Redirect(302, c.LoginPath())
		return
	}
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
	//this.TplName = "Resources/resourceform.tpl"
}
