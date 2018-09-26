package controllers

import (
	"fmt"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.dashboard/convert"
	"prm/com.omnicon.prm.dashboard/models"

	//Oauth
	"prm/com.omnicon.prm.oauth2_proxy/providers"
)

type BaseController struct {
	beego.Controller

	Userinfo *models.User
	IsLogin  bool
	Provider *providers.AzureProvider
	Session  *providers.SessionState
}

type NestPreparer interface {
	NestPrepare()
}

type NestFinisher interface {
	NestFinish()
}

func (c *BaseController) Prepare() {
	fmt.Println("base.Prepare")

	c.SetParams()

	fmt.Println("this.Session!=nil", c.Session != nil)
	c.IsLogin = c.GetSession("userinfo") != nil
	if c.IsLogin {
		c.Userinfo = c.GetLogin()
	}

	c.Data["IsLogin"] = c.IsLogin
	c.Data["Userinfo"] = c.Userinfo

	c.Layout = "base.tpl"

	if app, ok := c.AppController.(NestPreparer); ok {
		app.NestPrepare()
	}
}

func (c *BaseController) Finish() {
	if app, ok := c.AppController.(NestFinisher); ok {
		app.NestFinish()
	}
}

func (c *BaseController) GetLogin() *models.User {
	u := &models.User{Id: c.GetSession("userinfo").(int64)}
	u.Read()
	return u
}

func (c *BaseController) DelLogin() {
	c.DelSession("userinfo")
}

func (c *BaseController) SetLogin(user *models.User) {
	c.SetSession("userinfo", user.Id)
}

func (c *BaseController) LoginPath() string {
	return c.URLFor("LoginController.Login")
}

func (c *BaseController) SetParams() {
	c.Data["Params"] = make(map[string]string)
	for k, v := range c.Input() {
		c.Data["Params"].(map[string]string)[k] = v[0]
	}
}

func (c *BaseController) BuildRequestUrl(uri string) string {
	if uri == "" {
		uri = c.Ctx.Input.URI()
	}
	return fmt.Sprintf("%s:%s%s",
		c.Ctx.Input.Site(), convert.ToStr(c.Ctx.Input.Port()), uri)
}
