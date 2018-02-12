package controllers

import (
	"fmt"
	"net/http"
	"time"

	"github.com/astaxie/beego"
)

type MainController struct {
	BaseController
}

func (c *MainController) NestPrepare() {
	/*****COMENTAR********/
	tr := &http.Transport{
		MaxIdleConns:       10,
		IdleConnTimeout:    30 * time.Second,
		DisableCompression: true,
	}
	client := &http.Client{
		Transport: tr,
		//CheckRedirect: redirectPolicyFunc,
	}
	//resp, err :=
	client.Get("http://localhost:4180/oauth2/sign_in/")
	fmt.Println("Login***++++************")

	c.Ctx.Redirect(302, "http://localhost:4180/oauth2/sign_in/")
	/* COMENTAR///*/

	fmt.Println("NestPrepare - MainControler")
	fmt.Println(c.GetString("code"), c.GetString("session_state"))
	//url := "http://" + ctx.Input.Domain() + "4180" //ctx.Input.Uri()
	//	ctx.Redirect(302, url)
	if c.GetString("session_state") == "" {
		fmt.Println("redirect localhost:4180/oauth2/sign_in/")
		c.Ctx.Redirect(302, "http://localhost:4180/oauth2/sign_in/")
		//	c.Ctx.Redirect(302, c.URLFor("UsersController.Index"))
		return
	}

	if !c.IsLogin {
		//c.Ctx.Redirect(302, c.LoginPath(c.GetString("session_state")))
		fmt.Println("!c.IsLogin/", !c.IsLogin)
		return
	}
}

/*Index*/
func (c *MainController) Get() {

	fmt.Println(c.GetString("code"))

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
