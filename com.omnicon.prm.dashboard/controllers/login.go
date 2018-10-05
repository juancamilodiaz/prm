package controllers

import (
	"fmt"
	"html/template"
	"io/ioutil"
	"net/http"
	"net/smtp"

	//	"net/url"
	"os"
	"strings"
	"time"

	"github.com/astaxie/beego"

	"prm/com.omnicon.prm.dashboard/lib"
	"prm/com.omnicon.prm.dashboard/models"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/util"
)

//req &{POST https://login.microsoftonline.com/labmilanes.com/oauth2/token
const fileNameValidEmails = "conf/validEmails"

var superusers = beego.AppConfig.String("superusers")
var adminusers = beego.AppConfig.String("adminusers")
var planusers = beego.AppConfig.String("planusers")
var trainerusers = beego.AppConfig.String("trainerusers")

var serverip = beego.AppConfig.String("serverip")
var proxyip = beego.AppConfig.String("proxyip")
var httpport = beego.AppConfig.String("httpport")
var azureprovider = beego.AppConfig.String("azureprovider")
var protectedresource = beego.AppConfig.String("protectedresource")
var clientid = beego.AppConfig.String("clientid")
var clientsecret = beego.AppConfig.String("clientsecret")
var tenantid = beego.AppConfig.String("tenantid")

var su, _ = beego.AppConfig.Int("superuser")
var au, _ = beego.AppConfig.Int("adminuser")
var pu, _ = beego.AppConfig.Int("planuser")
var tu, _ = beego.AppConfig.Int("traineruser")
var du, _ = beego.AppConfig.Int("defaultuser")

type LoginController struct {
	BaseController
}

func (this *LoginController) Login() {

	fmt.Println("login.Login --  ****, this.IsLogin", this.IsLogin, "Session is Empty *****", this.Session == nil)

	if this.IsLogin {
		this.Ctx.Redirect(302, this.URLFor("UsersController.Index"))
		return
	}

	///oauth2/start
	session := this.Session
	if session != nil {
		fmt.Println("session2", session.AccessToken)
		fmt.Println("s.Email 4", session.Email)
		this.Provider.GetEmailAddress(session)
		this.Data["email"] = session.Email
		//this.TplName = "Projects/listResourceByProjectToday.tpl"
		this.TplName = "Projects/ProductivityReportNew.tpl"
	} else {
		tr := &http.Transport{
			MaxIdleConns:       10,
			IdleConnTimeout:    30 * time.Second,
			DisableCompression: true,
		}

		client := &http.Client{
			Transport: tr,
		}
		uri := BuildURI(false, serverip, proxyip, "oauth2", "start")
		client.Get(uri) //?rd=/oauth2/sign_in

		this.Redirect(uri, 307)

	}
	//this.TplName = "Projects/listResourceByProjectToday.tpl"
	this.TplName = "Projects/ProductivityReportNew.tpl"
}

func (c *LoginController) Logout() {
	c.DelLogin()
	flash := beego.NewFlash()
	flash.Success("Success logged out")
	flash.Store(&c.Controller)

	uriLogout := BuildURI(true, "login.microsoftonline.com", "", "labmilanes.com", "oauth2", "logout")
	uriRedirect := BuildURI(false, serverip, httpport)
	uriLogout = uriLogout + "?post_logout_redirect_uri=" + uriRedirect
	c.Ctx.Redirect(302, uriLogout)
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

	_, err = file.WriteString(";" + emailEnable)
	if err != nil {
		flash.Error("Internal Error writing Valid Emails.")
		flash.Store(&c.Controller)
	}

	input := domain.SettingsRQ{}
	input.Name = util.VALID_EMAILS
	content, _ := ioutil.ReadFile(fileNameValidEmails)
	input.Value = string(content)
	inputBuffer := EncoderInput(input)
	PostData("UpdateSettings", inputBuffer)

	flash.Success("Grant Successful.")
	flash.Store(&c.Controller)
}

// Validate if email already exist
func existEmail(pEmail string) bool {

	content, _ := ioutil.ReadFile(fileNameValidEmails)
	emails := string(content)
	for _, email := range strings.Split(emails, ";") {
		if strings.EqualFold(email, pEmail) {
			return true
		}
	}
	return false
}
