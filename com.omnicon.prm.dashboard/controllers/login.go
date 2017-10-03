package controllers

import (
	"html/template"
	"io/ioutil"
	"net/smtp"
	"os"
	"strings"

	"github.com/astaxie/beego"

	"prm/com.omnicon.prm.dashboard/lib"
	"prm/com.omnicon.prm.dashboard/models"
)

const fileNameValidEmails = "conf/validEmails"

var superusers = beego.AppConfig.String("superusers")

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

	c.Ctx.Redirect(302, "/")
	//c.Ctx.Redirect(302, c.URLFor("LoginController.Login"))
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

	// Valid email in white list
	if !existEmail(u.Email) {
		flash.Warning("Email is not allowed to be registered.")
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
	password, err := lib.ResetPassword(email, "")

	if err != nil {
		flash.Warning(err.Error())
		flash.Store(&c.Controller)
		return
	}

	// Send email
	err = sendMail(email, password)

	if err != nil {
		flash.Error("Error sending email.")
		flash.Store(&c.Controller)
		return
	}

	flash.Success("Mail sent successfully.")
	flash.Store(&c.Controller)
}

func (c *LoginController) ChangePassword() {
	c.TplName = "login/changePassword.tpl"
	c.Data["xsrfdata"] = template.HTML(c.XSRFFormHTML())

	if !c.Ctx.Input.IsPost() {
		return
	}

	var err error
	flash := beego.NewFlash()

	email := c.GetString("Email")
	oldPassword := c.GetString("OldPassword")
	password := c.GetString("Password")
	repassword := c.GetString("Repassword")

	user := &models.User{}
	user.Email = email
	user.Password = password
	user.Repassword = repassword
	if err = models.IsValid(user); err != nil {
		flash.Error(err.Error())
		flash.Store(&c.Controller)
		return
	}

	user, err = lib.Authenticate(email, oldPassword)
	if err != nil || user.Id < 1 {
		flash.Warning(err.Error())
		flash.Store(&c.Controller)
		return
	}

	password, err = lib.ResetPassword(email, password)

	if err != nil {
		flash.Warning(err.Error())
		flash.Store(&c.Controller)
		return
	}

	// Send email
	err = sendMail(email, password)

	if err != nil {
		flash.Error("Error sending email.")
		flash.Store(&c.Controller)
		return
	}

	flash.Success("Password updated.")
	flash.Store(&c.Controller)

}

// Function that send the email with the information of new password
func sendMail(pEmail, pPassword string) error {
	// Set up authentication information.
	auth := smtp.PlainAuth("", "prm.omnicon@gmail.com", "prm_omnicon", "smtp.gmail.com")

	// Connect to the server, authenticate, set the sender and recipient,
	// and send the email all in one step.
	to := []string{pEmail}
	msg := []byte("To: " + pEmail + "\r\n" +
		"Subject: [PRM] Password Reset\r\n" +
		"\r\n" +
		"Your new password is: " + pPassword + "\r\n")
	return smtp.SendMail("smtp.gmail.com:587", auth, "prm.omnicon@gmail.com", to, msg)
}

func (c *LoginController) GrantAccess() {
	c.TplName = "login/grantAccess.tpl"
	c.Data["xsrfdata"] = template.HTML(c.XSRFFormHTML())

	if !c.Ctx.Input.IsPost() {
		return
	}

	//var err error
	flash := beego.NewFlash()

	email := c.GetString("Email")
	password := c.GetString("Password")

	isSuperUser := false
	for _, superuser := range strings.Split(superusers, ";") {
		if strings.EqualFold(superuser, email) {
			isSuperUser = true
		}
	}
	if !isSuperUser {
		flash.Warning("The email is not superuser.")
		flash.Store(&c.Controller)
		return
	}

	user, err := lib.Authenticate(email, password)
	if err != nil || user.Id < 1 {
		flash.Warning(err.Error())
		flash.Store(&c.Controller)
		return
	}

	emailEnable := c.GetString("EmailEnable")
	if existEmail(emailEnable) {
		flash.Warning("The email is already enabled.")
		flash.Store(&c.Controller)
		return
	}

	file, err := os.OpenFile(fileNameValidEmails, os.O_RDWR|os.O_APPEND, 0660)
	if err != nil {
		file, err = os.Create(fileNameValidEmails)
		if err != nil {
			flash.Error("Internal Error reading Valid Emails.")
			flash.Store(&c.Controller)
		}
	}
	defer file.Close()

	_, err = file.WriteString(emailEnable + "\n")
	if err != nil {
		flash.Error("Internal Error writing Valid Emails.")
		flash.Store(&c.Controller)
	}

	flash.Success("Grant Successful.")
	flash.Store(&c.Controller)
}

// Validate if email already exist
func existEmail(pEmail string) bool {

	content, _ := ioutil.ReadFile(fileNameValidEmails)
	emails := string(content)
	for _, email := range strings.Split(emails, "\n") {
		if strings.EqualFold(email, pEmail) {
			return true
		}
	}
	return false
}