package controllers

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
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

type Respuesta struct {
	TokenType    string `json:"token_type"`
	Scope        string `json:"scope"`
	ExpiresIn    string `json:"expires_in`
	ExtExpiresIn string `json:"ext_expires_in"`
	ExpiresOn    string `json:"expires_on"`
	NotBefore    string `json:"not_before"`
	Resource     string `json:"resource"`
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	IdToken      string `json:"id_token"`
}

type PersonalInfoGraph struct {
	Odatacontext      string   `json:"@odata.context"`
	ID                string   `json:"id"`
	BusinessPhones    []string `json:"businessPhones"`
	DisplayName       string   `json:"displayName"`
	GivenName         string   `json:"givenName"`
	JobTitle          string   `json:"jobTitle"`
	Mail              string   `json:"mail"`
	MobilePhone       string   `json:"mobilePhone"`
	OfficeLocation    string   `json:"officeLocation"`
	PreferredLanguage string   `json:"preferredLanguage"`
	Surname           string   `json:"surname"`
	UserPrincipalName string   `json:"userPrincipalName"`
}

//var url string

func init() {
	provider = getAzureProvider(azureprovider)
	provider.ProtectedResource, _ = url.Parse(protectedresource)
	provider.ClientID = clientid
	provider.ClientSecret = clientsecret
	//fmt.Println("Azure Provider ", provider)
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
	//fmt.Println("OBJETO DE SESION", code)
	if err == nil {
		this.Session = session
		//fmt.Println("session", session.AccessToken)
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

/**
*  PersonalInFo Function to obtain the personal data of the person in session.
 */
func PersonalInFo() {

	url := "https://login.microsoftonline.com/omnicon.cc/oauth2/token"

	payload := strings.NewReader("client_id=8a72ec00-36fe-4197-a22a-8c70e01c304a&client_secret=7iHt3uOYcDWcSQaoZDp9CqYOpcUdplhbchw6OwSzoFw%3D&resource=https%3A%2F%2Fgraph.microsoft.com&grant_type=client_credentials")
	req, _ := http.NewRequest("POST", url, payload)
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")
	res, _ := http.DefaultClient.Do(req)
	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	message := Respuesta{}
	err := json.Unmarshal(body, &message)
	if err != nil {
		fmt.Println(err.Error())
	}

	url = "https://graph.microsoft.com/v1.0/users/" + session.Email
	req, _ = http.NewRequest("GET", url, nil)
	req.Header.Add("Accept", "application/json")
	req.Header.Add("Authorization", message.TokenType+" "+message.AccessToken)
	res, _ = http.DefaultClient.Do(req)
	defer res.Body.Close()
	body, _ = ioutil.ReadAll(res.Body)

	pinfo := PersonalInfoGraph{}
	err = json.Unmarshal(body, &pinfo)
	if err != nil {
		fmt.Println(err.Error())
	}
	session.PInfo.ID = pinfo.ID
	session.PInfo.BusinessPhones = pinfo.BusinessPhones
	session.PInfo.DisplayName = pinfo.DisplayName
	session.PInfo.GivenName = pinfo.GivenName
	session.PInfo.JobTitle = pinfo.JobTitle
	session.PInfo.Mail = pinfo.Mail
	session.PInfo.MobilePhone = pinfo.MobilePhone
	session.PInfo.Odatacontext = pinfo.Odatacontext
	session.PInfo.OfficeLocation = pinfo.OfficeLocation
	session.PInfo.PreferredLanguage = pinfo.PreferredLanguage
	session.PInfo.Surname = pinfo.Surname
	session.PInfo.UserPrincipalName = pinfo.UserPrincipalName

	//fmt.Println(session.PInfo)
	//fmt.Println(res)
	//fmt.Println(string(body))

	url = "https://graph.microsoft.com/v1.0/users/" + session.Email + "/photo/$value"
	req, _ = http.NewRequest("GET", url, nil)
	req.Header.Add("Accept", "application/json")
	req.Header.Add("Authorization", message.TokenType+" "+message.AccessToken)
	res, _ = http.DefaultClient.Do(req)
	defer res.Body.Close()
	body, _ = ioutil.ReadAll(res.Body)
	session.ProfPic.Picture = body
	if session.ProfPic.Picture != nil {
		fmt.Println("IMGAGE ALIVE")
	} else {
		fmt.Println("IMAGE DIE")
	}
	//fmt.Println(res)
	//fmt.Println(string(body))
}

func (this *AzureController) Get() {
	if session != nil {
		//	fmt.Println("s.AccessToken", session.AccessToken)
		fmt.Println("s.Email 3", session.Email)
		fmt.Println("session", session)

		flash := beego.NewFlash()
		email := session.Email

		user := &models.User{Email: email}

		flash.Success("Success logged in")
		flash.Store(&this.Controller)
		this.SetLogin(user)
		this.Session = session

		// Function to obtain the personal data of the person in session.
		PersonalInFo()
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

		uri := BuildURI(false, serverip, httpport) // Review if missing last /
		//		fmt.Println("test - 9-1") // ---------------------------------------------

		this.Redirect(uri, 307)

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

	this.TplName = "index.tpl" //
	//this.TplName = "Projects/listResourceByProjectToday.tpl"

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
