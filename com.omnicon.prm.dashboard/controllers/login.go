package controllers

import (
	"html/template"
	"net/smtp"

	"github.com/astaxie/beego"

	"prm/com.omnicon.prm.dashboard/lib"
	"prm/com.omnicon.prm.dashboard/models"
)

type LoginController struct {
	BaseController
}

func (c *LoginController) Login() {

	if c.IsLogin {
		c.Ctx.Redirect(302, c.URLFor("UsersController.Index"))
		return
	}

	c.TplName = "login/login.tpl"
	c.Data["xsrfdata"] = template.HTML(c.XSRFFormHTML())

	if !c.Ctx.Input.IsPost() {
		return
	}

	flash := beego.NewFlash()
	email := c.GetString("Email")
	password := c.GetString("Password")

	user, err := lib.Authenticate(email, password)
	if err != nil || user.Id < 1 {
		flash.Warning(err.Error())
		flash.Store(&c.Controller)
		return
	}

	flash.Success("Success logged in")
	flash.Store(&c.Controller)

	c.SetLogin(user)

	c.Redirect(c.URLFor("UsersController.Index"), 303)
}

func (c *LoginController) Logout() {
	c.DelLogin()
	flash := beego.NewFlash()
	flash.Success("Success logged out")
	flash.Store(&c.Controller)

	c.Ctx.Redirect(302, c.URLFor("LoginController.Login"))
}

func (c *LoginController) Signup() {
	c.TplName = "login/signup.tpl"
	c.Data["xsrfdata"] = template.HTML(c.XSRFFormHTML())

	if !c.Ctx.Input.IsPost() {
		return
	}

	var err error
	flash := beego.NewFlash()

	u := &models.User{}
	if err = c.ParseForm(u); err != nil {
		flash.Error("Signup invalid!")
		flash.Store(&c.Controller)
		return
	}
	if err = models.IsValid(u); err != nil {
		flash.Error(err.Error())
		flash.Store(&c.Controller)
		return
	}

	id, err := lib.SignupUser(u)
	if err != nil || id < 1 {
		flash.Warning(err.Error())
		flash.Store(&c.Controller)
		return
	}

	flash.Success("Register user")
	flash.Store(&c.Controller)

	c.SetLogin(u)

	c.Redirect(c.URLFor("UsersController.Index"), 303)
}

func (c *LoginController) PasswordReset() {
	c.TplName = "login/passwordReset.tpl"
	c.Data["xsrfdata"] = template.HTML(c.XSRFFormHTML())

	if !c.Ctx.Input.IsPost() {
		return
	}

	var err error
	flash := beego.NewFlash()

	email := c.GetString("Email")
	password, err := lib.ResetPassword(email)

	if err != nil {
		flash.Warning(err.Error())
		flash.Store(&c.Controller)
		return
	}

	// Set up authentication information.
	auth := smtp.PlainAuth("", "prm.omnicon@gmail.com", "prm_omnicon", "smtp.gmail.com")

	// Connect to the server, authenticate, set the sender and recipient,
	// and send the email all in one step.
	to := []string{email}
	msg := []byte("To: " + email + "\r\n" +
		"Subject: [PRM] Password Reset\r\n" +
		"\r\n" +
		"Your new password is: " + password + "\r\n")
	err = smtp.SendMail("smtp.gmail.com:587", auth, "anderson.diaz@omnicon.cc", to, msg)
	if err != nil {
		flash.Error("Error sending email.")
		flash.Store(&c.Controller)
		return
	}

	flash.Success("Mail sent successfully.")
	flash.Store(&c.Controller)
}
