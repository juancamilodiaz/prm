package controllers

import (
	"fmt"
	"net/http"
	"net/url"
	"time"

	"golang.org/x/net/context"
	"golang.org/x/oauth2"

	"encoding/json"

	"prm/com.omnicon.prm.oauth2_proxy/providers"

	"prm/com.omnicon.prm.dashboard/models"

	"github.com/astaxie/beego"
	"prm/com.omnicon.prm.service/domain"
	"prm/com.omnicon.prm.service/log"
)

var conf *oauth2.Config
var tenant string
var provider *providers.AzureProvider
var session *providers.SessionState

//var url string

func init() {
	fmt.Println("init init")

	provider = getAzureProvider(azureprovider)
	provider.ProtectedResource, _ = url.Parse(protectedresource)
	provider.ClientID = clientid
	provider.ClientSecret = clientsecret

	provider.Configure(tenantid)
}

func getAzureProvider(hostname string) *providers.AzureProvider {
	provider := providers.NewAzureProvider(
		&providers.ProviderData{
			ProviderName:      "",
			LoginURL:          &url.URL{},
			RedeemURL:         &url.URL{},
			ProfileURL:        &url.URL{},
			ValidateURL:       &url.URL{},
			ProtectedResource: &url.URL{},
			Scope:             ""})
	/*if hostname != "" {
		//&url.Scheme = "http"
		updateURL(provider.Data().LoginURL, hostname)
		updateURL(provider.Data().RedeemURL, hostname)
		updateURL(provider.Data().ProfileURL, hostname)
		updateURL(provider.Data().ValidateURL, hostname)
		updateURL(provider.Data().ProtectedResource, hostname)
	}*/
	return provider
}

func updateURL(url *url.URL, hostname string) {
	url.Scheme = "http"
	url.Host = hostname
}

type AzureController struct {
	BaseController
}

func (this *AzureController) Callback() {

	fmt.Println("Azure.Callback -- *****, Session is Empty:", this.Session)

	code := this.GetString("code")

	var err error
	uri := BuildURI(false, serverip, httpport, "oauth2", "callback")
	session, err = provider.Redeem(uri, code)
	if err == nil {
		this.Session = session
		fmt.Println("session", session.AccessToken)
		fmt.Println("s.Email 1", session.Email)
		this.IsLogin = true
		if session.Email == "" {
			session.Email, err = provider.GetEmailAddress(session)
			fmt.Println("s.Email 2", session.Email)

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

func (this *AzureController) Get() {
	if session != nil {
		fmt.Println("s.AccessToken", session.AccessToken)
		fmt.Println("s.Email 3", session.Email)
		fmt.Println("session", session)

		flash := beego.NewFlash()
		email := session.Email

		user := &models.User{Email: email}

		flash.Success("Success logged in")
		flash.Store(&this.Controller)

		this.SetLogin(user)
		this.Session = session

		operation := "GetResourcesToProjects"

		input := domain.GetResourcesToProjectsRQ{}
		input.Enabled = true
		err := this.ParseForm(&input)

		if err != nil {

			log.Error("[ParseInput]", input)
		}

		log.Debugf("[ParseInput] Input: %+v \n", input)

		inputBuffer := EncoderInput(input)

		res, err := PostData(operation, inputBuffer)

		if err == nil {

			defer res.Body.Close()
			message := new(domain.GetResourcesToProjectsRS)
			json.NewDecoder(res.Body).Decode(&message)
			this.Data["ResourcesToProjects"] = message.ResourcesToProjects
			this.Data["Projects"] = message.Projects
			this.Data["Resources"] = message.Resources
			this.Data["AvailBreakdown"] = message.AvailBreakdown
			this.Data["AvailBreakdownPerRange"] = message.AvailBreakdownPerRange
			this.Data["Title"] = input.ProjectName
		}

		//		uri := BuildURI(false, serverip, httpport) // Review if missing last /

		//		fmt.Println("test - 9-1") // ---------------------------------------------

		//		this.Redirect(uri, 307)

	} else {
		tr := &http.Transport{
			MaxIdleConns:       10,
			IdleConnTimeout:    30 * time.Second,
			DisableCompression: true,
		}

		client := &http.Client{
			Transport: tr,
		}

		uriGet := BuildURI(false, serverip, proxyip, "oauth2", "start")
		client.Get(uriGet) //?rd=/oauth2/sign_in

		this.Redirect(uriGet, 307)

	}

	this.TplName = "Projects/listResourceByProjectToday.tpl"

}

func (this *AzureController) Authorize() {
	fmt.Println("init Authorize")

	ctx := context.TODO()

	fmt.Println("--------------ctx--------------")
	fmt.Println("Value", ctx.Value(context.TODO()))
	fmt.Println("--------------conf--------------")
	fmt.Println("ClientID:", conf.ClientID)
	fmt.Println("ClientSecret:", conf.ClientSecret)
	fmt.Println("Endpoint:", conf.Endpoint)
}
