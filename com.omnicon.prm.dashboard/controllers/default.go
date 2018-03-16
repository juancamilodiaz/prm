package controllers

import (
	"fmt"

	"github.com/astaxie/beego"
)

type MainController struct {
	BaseController
}

func (c *MainController) NestPrepare() {
	fmt.Println("default.NestPrepare, c.IsLogin", c.IsLogin)
	if !c.IsLogin {
		c.Ctx.Redirect(302, c.LoginPath())
		return
	}
}

/*Index*/
func (c *MainController) Get() {
	fmt.Println("default.Get, c.IsLogin", c.IsLogin)
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
