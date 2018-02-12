package controllers

import (
	"fmt"
	"html/template"
	"io/ioutil"
	"net/smtp"
	"os"
	"strings"
	"time"

	"net/http"

	"github.com/astaxie/beego"

	"prm/com.omnicon.prm.dashboard/lib"
	"prm/com.omnicon.prm.dashboard/models"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/util"
)

const fileNameValidEmails = "conf/validEmails"

var superusers = beego.AppConfig.String("superusers")

type LoginController struct {
	BaseController
}

/*
func handler(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte("This is an example server.\n"))
}*/

func (c *LoginController) Login() {

	/*************/
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

	fmt.Println("Login***++++************", c.IsLogin)
	if c.IsLogin {
		c.Ctx.Redirect(302, c.URLFor("UsersController.Index"))
		return
	}
	/*
		c.TplName = "login/login.tpl"
		c.Data["xsrfdata"] = template.HTML(c.XSRFFormHTML())

			if !c.Ctx.Input.IsPost() {
				return
			}*/

	flash := beego.NewFlash()
	//email := c.GetString("Email")
	//password := c.GetString("Password")

	//user, err := lib.Authenticate(email, password)
	fmt.Println(c.GetString("code"))
	user, err := lib.AuthenticateSession(c.GetString("session_state"))
	if user != nil {
		fmt.Println("Success logged in", user.SessionState, " id: ", user.Id)
		if err != nil || user.Id < 1 {
			fmt.Println("Error login")
			flash.Warning(err.Error())
			flash.Store(&c.Controller)
			return
		}
	}

	fmt.Println("Success logged in")
	flash.Success("Success logged in")
	flash.Store(&c.Controller)

	if user != nil {
		c.SetLogin(user)
		c.Redirect(c.URLFor("UsersController.Index"), 303)
	} else {
		c.Redirect("localhost:4180/oauth2/sign_in/", 303)
	}

}

func (c *LoginController) Logout() {
	fmt.Println("Logout")
	c.DelLogin()
	flash := beego.NewFlash()
	flash.Success("Success logged out")
	fmt.Println("Success logged out")
	flash.Store(&c.Controller)

	//c.Ctx.Redirect(302, c.URLFor("localhost:4180/oauth2/sign_in"))
	//c.Ctx.Redirect(302, "localhost:4180")
	//c.Ctx.Redirect(302, c.URLFor("LoginController.Login"))

	c.Redirect(c.URLFor("localhost:4180/oauth2/sign_in"), 303)
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
