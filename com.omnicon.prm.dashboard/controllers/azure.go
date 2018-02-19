package controllers

import (
	"fmt"
	"net/http"
	"net/url"
	"time"

	"golang.org/x/net/context"
	"golang.org/x/oauth2"

	"prm/com.omnicon.prm.oauth2_proxy/providers"
	//	"prm/com.omnicon.prm.dashboard/convert"
	"encoding/json"

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

	provider = getAzureProvider("login.microsoftonline.com/omnicon.cc")
	provider.ProtectedResource, _ = url.Parse("https://omnicon.cc/prm_backend")
	provider.ClientID = "883b28e9-8d57-4b30-ba84-fac66a5ab933"
	provider.ClientSecret = "WPcgq52QJEjDKN9HTZGHm5J5TsiMe5HxHBAmKiymM2A="

	provider.Configure("omnicon.cc")
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
	fmt.Println("code", code)
	fmt.Println("session_state", this.GetString("session_state"))

	var err error
	session, err = provider.Redeem("http://localhost:8080/oauth2/callback", code)
	if err != nil {
		fmt.Println("errorrrr", err)
	} else {
		this.Session = session
		fmt.Println("session", session.AccessToken)
		fmt.Println("s.Email", session.Email)
		this.IsLogin = true
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

func (this *AzureController) Get() {
	fmt.Println("Azure.Get   --   *****")
	///oauth2/start
	if session != nil {
		fmt.Println("s.AccessToken", session.AccessToken)
		fmt.Println("s.Email", session.Email)

		flash := beego.NewFlash()
		email := session.Email
		//password := "123456789"

		user := &models.User{Email: email}

		/*
			user, err := lib.Authenticate(email, password)
			if err != nil || user.Id < 1 {
				flash.Warning(err.Error())
				flash.Store(&c.Controller)
				return
			}*/

		flash.Success("Success logged in")
		flash.Store(&this.Controller)

		this.SetLogin(user)
		this.Session = session

		//----
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
			//this.TplName = "Projects/listResourceByProjectToday.tpl"
			//this.TplName = "index.tpl"
		}

		this.Redirect("http://localhost:8080/", 307)
		//this.Redirect(this.URLFor("UsersController.Index"), 303)

		//	provider.GetLoginURL()
		//sr, _ := provider.GetEmailAddress(session)
		//fmt.Println("SDFSDFSDFSDFSDFSDFSDF::::::::", sr)
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

		rs, _ := client.Get("http://localhost:4180/oauth2/start") //?rd=/oauth2/sign_in
		fmt.Println("Login***++++************", rs.Status, rs.Body)

		this.Redirect("http://localhost:4180/oauth2/start", 307)

	}

	this.TplName = "Projects/listResourceByProjectToday.tpl"
}

func (this *AzureController) Authorize() {
	fmt.Println("init Authorize")
	//fmt.Printf("Redirect")
	//this.Redirect("https://login.microsoftonline.com/labmilanes.com/oauth2/authorize?access_type=online&client_id=00de0f7e-4398-41e4-a31b-1de5e30132b7&response_type=code&state=state", 307)

	/*ctx, cancel := context.WithTimeout(context.Background(), 1*time.Millisecond)
	defer cancel()
	select {
	case <-time.After(1 * time.Second):
		fmt.Println("overslept")
	case <-ctx.Done():
		fmt.Println(ctx.Err()) // prints "context deadline exceeded"
	}*/
	ctx := context.TODO()
	fmt.Println("1")
	// Use the authorization code that is pushed to the redirect
	// URL. Exchange will do the handshake to retrieve the
	// initial access token. The HTTP Client returned by
	// conf.Client will refresh the token as necessary.
	//	var code string
	//	code = "EBLA8asOxNm4SYU18Onp60vAeNwt9jkhWEzA1oVGqIc="

	//fmt.Println("2.Scan", ctx)
	/*if _, err := fmt.Scan(&code); err != nil {
		fmt.Println(err)
	}
	*/

	fmt.Println("--------------ctx--------------")
	fmt.Println("Value", ctx.Value(context.TODO()))
	fmt.Println("--------------conf--------------")
	fmt.Println("ClientID:", conf.ClientID)
	fmt.Println("ClientSecret:", conf.ClientSecret)
	fmt.Println("Endpoint:", conf.Endpoint)
	//	fmt.Println("Scopes:", conf.Scopes())

	fmt.Println("3.Exchange.....")
	/*tok, err := conf.Exchange(ctx, code)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("--------------tok--------------")
	fmt.Println("TokenType", tok.TokenType)
	fmt.Println("RefreshToken", tok.RefreshToken)
	fmt.Println("Valid", tok.Valid())
	*/

	//	resource := "https://labmilanes.com/af522b54-a9a7-4f9a-a285-574e94706977"

	//	myurl := conf.Endpoint.AuthURL + "?resource=" + resource
	//"https://login.microsoftonline.com/labmilanes.com/oautauthorizeh2/?resource=https://labmilanes.com/0a275dc9-3074-4f69-81c3-2820bb1528ba"
	//	contentType := ""

	/*fmt.Println("Client config")

	tok := new(oauth2.Token)
	tok.AccessToken = code
	tok.RefreshToken = code

	fmt.Println("AuthURL", conf.Endpoint.AuthURL)
	//fmt.Println("URL", url)

	client := conf.Client(ctx, tok)
	fmt.Println("****", client)
	fmt.Println("****")
	res, err := client.Get(url)
	if err != nil {
		fmt.Println("ERROR---", err)
	}
	fmt.Printf("RES", myurl)
	//defer res.Close()
	fmt.Println(res.Body)

	this.Redirect(url, 307)
	*/
}
