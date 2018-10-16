package controllers

import (
	"encoding/json"
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
	//fmt.Println("default.Get, c.IsLogin", c.IsLogin)

	personalInformation, err := json.Marshal(session.PInfo)
	profilePicture, err := json.Marshal(session.ProfPic)

	if err != nil {
		fmt.Println(err)
		return
	}
	c.Data["Website"] = "beego.me"
	c.Data["Email"] = "astaxie@gmail.com"
	c.Data["PersonalInformation"] = string(personalInformation)
	c.Data["ProfilePicture"] = string(profilePicture)
	c.TplName = "index.tpl"
}

type AboutController struct {
	beego.Controller
}

func (this *AboutController) About() {

	this.TplName = "about.tpl"
	this.TplName = "Resources/resourceform.tpl"
}
