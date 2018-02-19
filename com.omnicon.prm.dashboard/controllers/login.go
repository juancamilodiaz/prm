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

type LoginController struct {
	BaseController
}

/*
func (this *LoginController) Callback() {

	fmt.Println("****Callback-Get**")

	code := this.GetString("code")
	fmt.Println("code", code)
	fmt.Println("session_state", this.GetString("session_state"))

	var err error
	//http://localhost:8081/oauth2/callback?code=AQABAAIAAABHh4kmS_aKT5XrjzxRAtHzvNxZCIZR0QqBI8cYlh5_aKgq4uhHDNKEINLHCuZqHkRlN36jUUHUik4WgSvMXir3xPXJU-T00kaeog4aefikGtYrvlfRjRM3ijWTJF1yiT2NKzBZemD--fpEu20G_a2Ujzw1HntofxiE76Hf7G2uDektH-YOgzl1GFo4KdFGSOTcnMcvr0JL2ygg7nY9JWyMp91IF2yxk52XqYVL5evFSYOHoNRWbF6DwMneJUjgsglfpaiu8y3nYAq0UMuthSdoKE9jh8fDdYNHQNUc837e9FlrtK-zGI-ek-DvmyMMyJnqmPLYl2uq01Jj1v1JIvmAekqqA7rwfVhWB1-teOzHbsj5J8cfhCehFFBciL78SYUrrSlq0b9ylcaXxEN-Nrt-PxH28NROybI5pn0yFzc5s6mxvjR2se354N6qikZXl1k-HWvxjxTrIoxTnYFWuImhZP4jJz4dBX3qBG8-x6wzpITtKBQ2664kEbUKq1qHiTflSU2mh-A91RyV2surracp4-kk4fuJgZFSNJ1vg6oopiAA&state=204658ec347489b39517173e8801adb0%3a%2foauth2%2fsign_in%2f&session_state=8be49d97-5e59-4203-b228-f2c3df24a400
	provider := this.Provider
	session := this.Session
	fmt.Println("callback this.Session==nil", this.Session == nil)
	if session == nil {
		session, err = this.Provider.Redeem("http://localhost:8081/oauth2/callback", code)
		if err != nil {
			fmt.Println("errorrrr", err)
		}
		this.Session = session
	}
	fmt.Println("callback this.Session==nil", this.Session == nil)

	if session != nil {
		fmt.Println("session", session.AccessToken)
		fmt.Println("s.Email", session.Email)
		this.IsLogin = true
		fmt.Println("this.IsLogin", this.IsLogin)

		if session.Email == "" {
			session.Email, err = provider.GetEmailAddress(session)
			fmt.Println("s.Email", session.Email)

			fmt.Println("this.IsLogin", this.IsLogin)
		}

		if session.User == "" {
			fmt.Println("s.User", session.User)
			session.User, err = provider.GetUserName(session)
			if err != nil && err.Error() == "not implemented" {
				err = nil
			}
			fmt.Println("s.User", session.User)
		}
	}

	this.Ctx.Redirect(302, this.URLFor("UsersController.Index"))

}
*/
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
		fmt.Println("s.Email", session.Email)
		//	provider.GetLoginURL()
		sr, _ := this.Provider.GetEmailAddress(session)

		fmt.Println("SDFSDFSDFSDFSDFSDFSDF::::::::", sr)
		//this.Ctx.Redirect(302, this.URLFor("UsersController.Index"))
		this.TplName = "Projects/listResourceByProjectToday.tpl"
	} else {
		//code := "code"
		//session, _ = provider.Redeem("http://localhost:4180/oauth2/start", code)
		/******** *****/
		tr := &http.Transport{
			MaxIdleConns:       10,
			IdleConnTimeout:    30 * time.Second,
			DisableCompression: true,
		}

		//cookieJar, _ := cookiejar.New(nil)

		client := &http.Client{
			//	Jar:       cookieJar,
			Transport: tr,
			//CheckRedirect: redirectPolicyFunc,
		}

		rs, err := client.Get("http://localhost:4180/oauth2/start") //?rd=/oauth2/sign_in
		if rs != nil {
			fmt.Println("Login***++++************", rs.Status, rs.Body)
		} else {
			fmt.Println("Login***++++************", err.Error())
		}

		this.Redirect("http://localhost:4180/oauth2/start", 307)

	}

	this.TplName = "Projects/listResourceByProjectToday.tpl"
}

/*
func (c *LoginController) Login() {

	fmt.Println("***LoginController****", c.IsLogin)
	if c.IsLogin {
		c.Ctx.Redirect(302, c.URLFor("UsersController.Index"))
		return
	}

	c.TplName = "login/login.tpl"
	c.Data["xsrfdata"] = template.HTML(c.XSRFFormHTML())
	//c.Data["ProxyPrefix"] =
	c.Data["Redirect"] = "sign_in"

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
}*/

func (c *LoginController) Logout() {
	c.DelLogin()
	flash := beego.NewFlash()
	flash.Success("Success logged out")
	flash.Store(&c.Controller)

	//c.Ctx.Redirect(302, "/")

	c.Ctx.Redirect(302, "https://login.microsoftonline.com/labmilanes.com/oauth2/logout?post_logout_redirect_uri=http://localhost:8081")
	//c.Ctx.Redirect(302, "http://localhost:4180/")
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
