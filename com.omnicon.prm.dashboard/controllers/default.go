package controllers

import (
	"fmt"
)

type MainController struct {
	BaseController
}

/*
func (c *MainController) NestPrepare() {
	fmt.Println("default.NestPrepare, c.IsLogin", c.IsLogin)
	if !c.IsLogin {
		c.Ctx.Redirect(302, c.LoginPath())
		return
	}
}*/

/*Index*/
func (this *MainController) Get() {
	fmt.Println("------------------DEFAULT.GET()------------------------")

	uri := BuildURI(false, serverip, httpport)
	if session != nil {
		this.TplName = "index.tpl"
		uri = uri + "/login"
	} else {
		// Review if missing last /
		uri = uri + "/start"
	}
	fmt.Println(uri)
	this.Redirect(uri, 307)

	/*if app, ok := c.AppController.(NestPreparer); ok {
		app.NestPrepare()
	}*/
}
