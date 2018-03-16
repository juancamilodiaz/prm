package main

import (
	b64 "encoding/base64"
	"errors"
	"fmt"
	"html/template"
	"log"
	"net"
	"net/http"
	"net/http/httputil"
	"net/url"
	"regexp"
	"strings"
	"time"

	"github.com/mbland/hmacauth"
	"prm/com.omnicon.prm.oauth2_proxy/cookie"
	"prm/com.omnicon.prm.oauth2_proxy/providers"
)

const SignatureHeader = "GAP-Signature"

var SignatureHeaders []string = []string{
	"Content-Length",
	"Content-Md5",
	"Content-Type",
	"Date",
	"Authorization",
	"X-Forwarded-User",
	"X-Forwarded-Email",
	"X-Forwarded-Access-Token",
	"Cookie",
	"Gap-Auth",
}

type OAuthProxy struct {
	CookieSeed     string
	CookieName     string
	CSRFCookieName string
	CookieDomain   string
	CookieSecure   bool
	CookieHttpOnly bool
	CookieExpire   time.Duration
	CookieRefresh  time.Duration
	Validator      func(string) bool

	RobotsPath        string
	PingPath          string
	SignInPath        string
	SignOutPath       string
	OAuthStartPath    string
	OAuthCallbackPath string
	AuthOnlyPath      string

	redirectURL         *url.URL // the url to receive requests at
	provider            providers.Provider
	ProxyPrefix         string
	SignInMessage       string
	HtpasswdFile        *HtpasswdFile
	DisplayHtpasswdForm bool
	serveMux            http.Handler
	SetXAuthRequest     bool
	PassBasicAuth       bool
	SkipProviderButton  bool
	PassUserHeaders     bool
	BasicAuthPassword   string
	PassAccessToken     bool
	CookieCipher        *cookie.Cipher
	skipAuthRegex       []string
	skipAuthPreflight   bool
	compiledRegex       []*regexp.Regexp
	templates           *template.Template
	Footer              string
}

type UpstreamProxy struct {
	upstream string
	handler  http.Handler
	auth     hmacauth.HmacAuth
}

func (u *UpstreamProxy) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("GAP-Upstream-Address", u.upstream)
	if u.auth != nil {
		r.Header.Set("GAP-Auth", w.Header().Get("GAP-Auth"))
		u.auth.SignRequest(r)
	}
	u.handler.ServeHTTP(w, r)
}

func NewReverseProxy(target *url.URL) (proxy *httputil.ReverseProxy) {
	return httputil.NewSingleHostReverseProxy(target)
}
func setProxyUpstreamHostHeader(proxy *httputil.ReverseProxy, target *url.URL) {
	director := proxy.Director
	proxy.Director = func(req *http.Request) {
		director(req)
		// use RequestURI so that we aren't unescaping encoded slashes in the request path
		req.Host = target.Host
		req.URL.Opaque = req.RequestURI
		req.URL.RawQuery = ""
	}
}
func setProxyDirector(proxy *httputil.ReverseProxy) {
	director := proxy.Director
	proxy.Director = func(req *http.Request) {
		director(req)
		// use RequestURI so that we aren't unescaping encoded slashes in the request path
		req.URL.Opaque = req.RequestURI
		req.URL.RawQuery = ""
	}
}
func NewFileServer(path string, filesystemPath string) (proxy http.Handler) {
	return http.StripPrefix(path, http.FileServer(http.Dir(filesystemPath)))
}

func NewOAuthProxy(opts *Options, validator func(string) bool) *OAuthProxy {
	serveMux := http.NewServeMux()
	var auth hmacauth.HmacAuth
	if sigData := opts.signatureData; sigData != nil {
		auth = hmacauth.NewHmacAuth(sigData.hash, []byte(sigData.key),
			SignatureHeader, SignatureHeaders)
	}
	for _, u := range opts.proxyURLs {
		path := u.Path
		switch u.Scheme {
		case "http", "https":
			u.Path = ""
			log.Printf("mapping path %q => upstream %q", path, u)
			proxy := NewReverseProxy(u)
			if !opts.PassHostHeader {
				setProxyUpstreamHostHeader(proxy, u)
			} else {
				setProxyDirector(proxy)
			}
			serveMux.Handle(path,
				&UpstreamProxy{u.Host, proxy, auth})
		case "file":
			if u.Fragment != "" {
				path = u.Fragment
			}
			log.Printf("mapping path %q => file system %q", path, u.Path)
			proxy := NewFileServer(path, u.Path)
			serveMux.Handle(path, &UpstreamProxy{path, proxy, nil})
		default:
			panic(fmt.Sprintf("unknown upstream protocol %s", u.Scheme))
		}
	}
	for _, u := range opts.CompiledRegex {
		log.Printf("compiled skip-auth-regex => %q", u)
	}

	redirectURL := opts.redirectURL
	redirectURL.Path = fmt.Sprintf("%s/callback", opts.ProxyPrefix)

	log.Printf("OAuthProxy configured for %s Client ID: %s", opts.provider.Data().ProviderName, opts.ClientID)
	refresh := "disabled"
	if opts.CookieRefresh != time.Duration(0) {
		refresh = fmt.Sprintf("after %s", opts.CookieRefresh)
	}

	log.Printf("Cookie settings: name:%s secure(https):%v httponly:%v expiry:%s domain:%s refresh:%s", opts.CookieName, opts.CookieSecure, opts.CookieHttpOnly, opts.CookieExpire, opts.CookieDomain, refresh)

	var cipher *cookie.Cipher
	if opts.PassAccessToken || (opts.CookieRefresh != time.Duration(0)) {
		var err error
		cipher, err = cookie.NewCipher(secretBytes(opts.CookieSecret))
		if err != nil {
			log.Fatal("cookie-secret error: ", err)
		}
	}

	return &OAuthProxy{
		CookieName:     opts.CookieName,
		CSRFCookieName: fmt.Sprintf("%v_%v", opts.CookieName, "csrf"),
		CookieSeed:     opts.CookieSecret,
		CookieDomain:   opts.CookieDomain,
		CookieSecure:   opts.CookieSecure,
		CookieHttpOnly: opts.CookieHttpOnly,
		CookieExpire:   opts.CookieExpire,
		CookieRefresh:  opts.CookieRefresh,
		Validator:      validator,

		RobotsPath:        "/robots.txt",
		PingPath:          "/ping",
		SignInPath:        fmt.Sprintf("%s/sign_in", opts.ProxyPrefix),
		SignOutPath:       fmt.Sprintf("%s/sign_out", opts.ProxyPrefix),
		OAuthStartPath:    fmt.Sprintf("%s/start", opts.ProxyPrefix),
		OAuthCallbackPath: fmt.Sprintf("%s/callback", opts.ProxyPrefix),
		AuthOnlyPath:      fmt.Sprintf("%s/auth", opts.ProxyPrefix),

		ProxyPrefix:        opts.ProxyPrefix,
		provider:           opts.provider,
		serveMux:           serveMux,
		redirectURL:        redirectURL,
		skipAuthRegex:      opts.SkipAuthRegex,
		skipAuthPreflight:  opts.SkipAuthPreflight,
		compiledRegex:      opts.CompiledRegex,
		SetXAuthRequest:    opts.SetXAuthRequest,
		PassBasicAuth:      opts.PassBasicAuth,
		PassUserHeaders:    opts.PassUserHeaders,
		BasicAuthPassword:  opts.BasicAuthPassword,
		PassAccessToken:    opts.PassAccessToken,
		SkipProviderButton: opts.SkipProviderButton,
		CookieCipher:       cipher,
		templates:          loadTemplates(opts.CustomTemplatesDir),
		Footer:             opts.Footer,
	}
}

func (p *OAuthProxy) GetRedirectURI(host string) string {
	// default to the request Host if not set
	if p.redirectURL.Host != "" {
		return p.redirectURL.String()
	}
	var u url.URL
	u = *p.redirectURL
	if u.Scheme == "" {
		if p.CookieSecure {
			u.Scheme = "https"
		} else {
			u.Scheme = "http"
		}
	}
	u.Host = host
	return u.String()
}

func (p *OAuthProxy) displayCustomLoginForm() bool {
	return p.HtpasswdFile != nil && p.DisplayHtpasswdForm
}

func (p *OAuthProxy) redeemCode(host, code string) (s *providers.SessionState, err error) {
	fmt.Println("code", code)
	if code == "" {
		return nil, errors.New("missing code")
	}
	redirectURI := p.GetRedirectURI(host)
	s, err = p.provider.Redeem(redirectURI, code)
	fmt.Println("s", s)
	if err != nil {
		return
	}

	if s.Email == "" {
		s.Email, err = p.provider.GetEmailAddress(s)
	}

	if s.User == "" {
		s.User, err = p.provider.GetUserName(s)
		if err != nil && err.Error() == "not implemented" {
			err = nil
		}
	}
	return
}

func (p *OAuthProxy) MakeSessionCookie(req *http.Request, value string, expiration time.Duration, now time.Time) *http.Cookie {
	if value != "" {
		value = cookie.SignedValue(p.CookieSeed, p.CookieName, value, now)
		if len(value) > 4096 {
			// Cookies cannot be larger than 4kb
			log.Printf("WARNING - Cookie Size: %d bytes", len(value))
		}
	}
	return p.makeCookie(req, p.CookieName, value, expiration, now)
}

func (p *OAuthProxy) MakeCSRFCookie(req *http.Request, value string, expiration time.Duration, now time.Time) *http.Cookie {
	return p.makeCookie(req, p.CSRFCookieName, value, expiration, now)
}

func (p *OAuthProxy) makeCookie(req *http.Request, name string, value string, expiration time.Duration, now time.Time) *http.Cookie {
	if p.CookieDomain != "" {
		domain := req.Host
		if h, _, err := net.SplitHostPort(domain); err == nil {
			domain = h
		}
		if !strings.HasSuffix(domain, p.CookieDomain) {
			log.Printf("Warning: request host is %q but using configured cookie domain of %q", domain, p.CookieDomain)
		}
	}

	return &http.Cookie{
		Name:     name,
		Value:    value,
		Path:     "/",
		Domain:   p.CookieDomain,
		HttpOnly: p.CookieHttpOnly,
		Secure:   p.CookieSecure,
		Expires:  now.Add(expiration),
	}
}

func (p *OAuthProxy) ClearCSRFCookie(rw http.ResponseWriter, req *http.Request) {
	http.SetCookie(rw, p.MakeCSRFCookie(req, "", time.Hour*-1, time.Now()))
}

func (p *OAuthProxy) SetCSRFCookie(rw http.ResponseWriter, req *http.Request, val string) {
	http.SetCookie(rw, p.MakeCSRFCookie(req, val, p.CookieExpire, time.Now()))
}

func (p *OAuthProxy) ClearSessionCookie(rw http.ResponseWriter, req *http.Request) {
	clr := p.MakeSessionCookie(req, "", time.Hour*-1, time.Now())
	http.SetCookie(rw, clr)

	// ugly hack because default domain changed
	if p.CookieDomain == "" {
		clr2 := *clr
		clr2.Domain = req.Host
		http.SetCookie(rw, &clr2)
	}
}

func (p *OAuthProxy) SetSessionCookie(rw http.ResponseWriter, req *http.Request, val string) {
	http.SetCookie(rw, p.MakeSessionCookie(req, val, p.CookieExpire, time.Now()))
}

func (p *OAuthProxy) LoadCookiedSession(req *http.Request) (*providers.SessionState, time.Duration, error) {
	var age time.Duration
	c, err := req.Cookie(p.CookieName)
	if err != nil {
		// always http.ErrNoCookie
		return nil, age, fmt.Errorf("Cookie %q not present", p.CookieName)
	}
	val, timestamp, ok := cookie.Validate(c, p.CookieSeed, p.CookieExpire)
	if !ok {
		return nil, age, errors.New("Cookie Signature not valid")
	}

	session, err := p.provider.SessionFromCookie(val, p.CookieCipher)
	if err != nil {
		return nil, age, err
	}

	age = time.Now().Truncate(time.Second).Sub(timestamp)
	return session, age, nil
}

func (p *OAuthProxy) SaveSession(rw http.ResponseWriter, req *http.Request, s *providers.SessionState) error {
	value, err := p.provider.CookieForSession(s, p.CookieCipher)
	if err != nil {
		return err
	}
	p.SetSessionCookie(rw, req, value)
	return nil
}

func (p *OAuthProxy) RobotsTxt(rw http.ResponseWriter) {
	rw.WriteHeader(http.StatusOK)
	fmt.Fprintf(rw, "User-agent: *\nDisallow: /")
}

func (p *OAuthProxy) PingPage(rw http.ResponseWriter) {
	rw.WriteHeader(http.StatusOK)
	fmt.Fprintf(rw, "OK")
}

func (p *OAuthProxy) ErrorPage(rw http.ResponseWriter, code int, title string, message string) {
	log.Printf("ErrorPage %d %s %s", code, title, message)
	rw.WriteHeader(code)
	t := struct {
		Title       string
		Message     string
		ProxyPrefix string
	}{
		Title:       fmt.Sprintf("%d %s", code, title),
		Message:     message,
		ProxyPrefix: p.ProxyPrefix,
	}
	p.templates.ExecuteTemplate(rw, "error.html", t)
}

func (p *OAuthProxy) SignInPage(rw http.ResponseWriter, req *http.Request, code int) {
	p.ClearSessionCookie(rw, req)
	rw.WriteHeader(code)

	redirect_url := req.URL.RequestURI()
	if req.Header.Get("X-Auth-Request-Redirect") != "" {
		redirect_url = req.Header.Get("X-Auth-Request-Redirect")
	}
	if redirect_url == p.SignInPath {
		redirect_url = "/"
	}

	t := struct {
		ProviderName  string
		SignInMessage string
		CustomLogin   bool
		Redirect      string
		Version       string
		ProxyPrefix   string
		Footer        template.HTML
	}{
		ProviderName:  p.provider.Data().ProviderName,
		SignInMessage: p.SignInMessage,
		CustomLogin:   p.displayCustomLoginForm(),
		Redirect:      redirect_url,
		Version:       VERSION,
		ProxyPrefix:   p.ProxyPrefix,
		Footer:        template.HTML(p.Footer),
	}
	p.templates.ExecuteTemplate(rw, "sign_in.html", t)
}

func (p *OAuthProxy) ManualSignIn(rw http.ResponseWriter, req *http.Request) (string, bool) {
	if req.Method != "POST" || p.HtpasswdFile == nil {
		return "", false
	}
	user := req.FormValue("username")
	passwd := req.FormValue("password")
	if user == "" {
		return "", false
	}
	// check auth
	if p.HtpasswdFile.Validate(user, passwd) {
		log.Printf("authenticated %q via HtpasswdFile", user)
		return user, true
	}
	return "", false
}

func (p *OAuthProxy) GetRedirect(req *http.Request) (redirect string, err error) {
	err = req.ParseForm()
	if err != nil {
		return
	}

	redirect = req.Form.Get("rd")
	if redirect == "" || !strings.HasPrefix(redirect, "/") || strings.HasPrefix(redirect, "//") {
		redirect = "/"
	}

	return
}

func (p *OAuthProxy) IsWhitelistedRequest(req *http.Request) (ok bool) {
	isPreflightRequestAllowed := p.skipAuthPreflight && req.Method == "OPTIONS"
	return isPreflightRequestAllowed || p.IsWhitelistedPath(req.URL.Path)
}

func (p *OAuthProxy) IsWhitelistedPath(path string) (ok bool) {
	for _, u := range p.compiledRegex {
		ok = u.MatchString(path)
		if ok {
			return
		}
	}
	return
}

func getRemoteAddr(req *http.Request) (s string) {
	s = req.RemoteAddr
	if req.Header.Get("X-Real-IP") != "" {
		s += fmt.Sprintf(" (%q)", req.Header.Get("X-Real-IP"))
	}
	return
}

func (p *OAuthProxy) ServeHTTP(rw http.ResponseWriter, req *http.Request) {

	fmt.Println("**PATH", req.URL.Path)
	fmt.Println("**SignInPath", p.SignInPath)
	switch path := req.URL.Path; {
	case path == p.RobotsPath:
		p.RobotsTxt(rw)
	case path == p.PingPath:
		p.PingPage(rw)
	case p.IsWhitelistedRequest(req):
		p.serveMux.ServeHTTP(rw, req)
	case path == p.SignInPath:
		p.SignIn(rw, req)
	case path == p.SignOutPath:
		p.SignOut(rw, req)
	case path == p.OAuthStartPath:
		p.OAuthStart(rw, req)
	case path == p.OAuthCallbackPath:
		p.OAuthCallback(rw, req)
	case path == p.AuthOnlyPath:
		p.AuthenticateOnly(rw, req)
	default:
		p.Proxy(rw, req)
	}
}

func (p *OAuthProxy) SignIn(rw http.ResponseWriter, req *http.Request) {
	redirect, err := p.GetRedirect(req)
	if err != nil {
		p.ErrorPage(rw, 500, "Internal Error", err.Error())
		return
	}

	fmt.Println("SIGN-IN")
	user, ok := p.ManualSignIn(rw, req)
	fmt.Println("ManualSignIn", user, ok)
	if ok {
		session := &providers.SessionState{User: user}
		fmt.Println("session", session)
		fmt.Println("redirect", redirect)
		p.SaveSession(rw, req, session)
		http.Redirect(rw, req, redirect, 302)
	} else {
		fmt.Println("SkipProviderButton", p.SkipProviderButton)
		if p.SkipProviderButton {
			p.OAuthStart(rw, req)
		} else {
			p.SignInPage(rw, req, http.StatusOK)
		}
	}
}

func (p *OAuthProxy) SignOut(rw http.ResponseWriter, req *http.Request) {
	fmt.Println("PRINT SignOut")
	/*redirect, err := p.GetRedirect(req)
	if err != nil {
		p.ErrorPage(rw, 500, "Internal Error", err.Error())
		return
	}

	p.ClearSessionCookie(rw, req)
	http.Redirect(rw, req, "/", 302)*/

	nonce, err := cookie.Nonce()
	if err != nil {
		p.ErrorPage(rw, 500, "Internal Error", err.Error())
		return
	}
	p.SetCSRFCookie(rw, req, nonce)

	redirect, err := p.GetRedirect(req)
	if err != nil {
		p.ErrorPage(rw, 500, "Internal Error", err.Error())
		return
	}
	fmt.Println("HOST", req.Host)
	//p.ClearSessionCookie(rw, req)
	//redirectURI := p.provider.GetLogoutURL(p.GetRedirectURI(req.Host)) //
	redirectURI := "https://login.microsoftonline.com/labmilanes.com/oauth2/logout"
	fmt.Println("redirectURI", redirectURI)
	http.Redirect(rw, req, p.provider.GetLoginURL(redirectURI, fmt.Sprintf("%v:%v", nonce, redirect)), 302)

}

func (p *OAuthProxy) OAuthStart(rw http.ResponseWriter, req *http.Request) {
	nonce, err := cookie.Nonce()
	if err != nil {
		p.ErrorPage(rw, 500, "Internal Error", err.Error())
		return
	}
	p.SetCSRFCookie(rw, req, nonce)
	redirect, err := p.GetRedirect(req)
	if err != nil {
		p.ErrorPage(rw, 500, "Internal Error", err.Error())
		return
	}
	redirectURI := p.GetRedirectURI(req.Host)
	http.Redirect(rw, req, p.provider.GetLoginURL(redirectURI, fmt.Sprintf("%v:%v", nonce, redirect)), 302)
}

func (p *OAuthProxy) OAuthCallback(rw http.ResponseWriter, req *http.Request) {
	remoteAddr := getRemoteAddr(req)

	// finish the oauth cycle
	err := req.ParseForm()
	if err != nil {
		p.ErrorPage(rw, 500, "Internal Error", err.Error())
		return
	}
	errorString := req.Form.Get("error")
	if errorString != "" {
		p.ErrorPage(rw, 403, "Permission Denied", errorString)
		return
	}
	session, err := p.redeemCode(req.Host, req.Form.Get("code"))
	if err != nil {
		log.Printf("%s error redeeming code %s", remoteAddr, err)
		p.ErrorPage(rw, 500, "Internal Error", "Internal Error")
		return
	}

	s := strings.SplitN(req.Form.Get("state"), ":", 2)
	if len(s) != 2 {
		p.ErrorPage(rw, 500, "Internal Error", "Invalid State")
		return
	}
	nonce := s[0]
	redirect := s[1]
	c, err := req.Cookie(p.CSRFCookieName)
	if err != nil {
		p.ErrorPage(rw, 403, "Permission Denied", err.Error())
		return
	}
	p.ClearCSRFCookie(rw, req)
	if c.Value != nonce {
		log.Printf("%s csrf token mismatch, potential attack", remoteAddr)
		p.ErrorPage(rw, 403, "Permission Denied", "csrf failed")
		return
	}

	if !strings.HasPrefix(redirect, "/") || strings.HasPrefix(redirect, "//") {
		redirect = "/"
	}

	// set cookie, or deny
	if p.Validator(session.Email) && p.provider.ValidateGroup(session.Email) {
		log.Printf("%s authentication complete %s", remoteAddr, session)
		err := p.SaveSession(rw, req, session)
		if err != nil {
			log.Printf("%s %s", remoteAddr, err)
			p.ErrorPage(rw, 500, "Internal Error", "Internal Error")
			return
		}
		//rw.Write([]byte("401 - PRM Login success"))

		fmt.Println("-Email", session.Email)
		rw.Header().Set("PRMail", session.Email)
		//http.Redirect(rw, req, "http://localhost:8080", 302) //redirect, 302)
	} else {
		log.Printf("%s Permission Denied: %q is unauthorized", remoteAddr, session.Email)
		p.ErrorPage(rw, 403, "Permission Denied", "Invalid Account")
	}
}

func (p *OAuthProxy) AuthenticateOnly(rw http.ResponseWriter, req *http.Request) {

	status := p.Authenticate(rw, req)
	fmt.Println("---------------status", status)
	if status == http.StatusAccepted {
		fmt.Println("---------------StatusAccepted", http.StatusAccepted)
		//http.Redirect(rw, req, "http://localhost:8080", 302) //redirect, 302)
		rw.WriteHeader(http.StatusAccepted)
	} else {
		fmt.Println("---------------unauthorized reques")
		http.Error(rw, "unauthorized request", http.StatusUnauthorized)
	}
}

func (p *OAuthProxy) Proxy(rw http.ResponseWriter, req *http.Request) {
	status := p.Authenticate(rw, req)
	if status == http.StatusInternalServerError {
		p.ErrorPage(rw, http.StatusInternalServerError,
			"Internal Error", "Internal Error")
	} else if status == http.StatusForbidden {
		if p.SkipProviderButton {
			p.OAuthStart(rw, req)
		} else {
			p.SignInPage(rw, req, http.StatusForbidden)
		}
	} else {
		p.serveMux.ServeHTTP(rw, req)
	}
}

func (p *OAuthProxy) Authenticate(rw http.ResponseWriter, req *http.Request) int {
	var saveSession, clearSession, revalidated bool
	remoteAddr := getRemoteAddr(req)

	session, sessionAge, err := p.LoadCookiedSession(req)
	if err != nil {
		log.Printf("%s %s", remoteAddr, err)
	}
	if session != nil && sessionAge > p.CookieRefresh && p.CookieRefresh != time.Duration(0) {
		log.Printf("%s refreshing %s old session cookie for %s (refresh after %s)", remoteAddr, sessionAge, session, p.CookieRefresh)
		saveSession = true
	}

	if ok, err := p.provider.RefreshSessionIfNeeded(session); err != nil {
		log.Printf("%s removing session. error refreshing access token %s %s", remoteAddr, err, session)
		clearSession = true
		session = nil
	} else if ok {
		saveSession = true
		revalidated = true
	}

	if session != nil && session.IsExpired() {
		log.Printf("%s removing session. token expired %s", remoteAddr, session)
		session = nil
		saveSession = false
		clearSession = true
	}

	if saveSession && !revalidated && session != nil && session.AccessToken != "" {
		if !p.provider.ValidateSessionState(session) {
			log.Printf("%s removing session. error validating %s", remoteAddr, session)
			saveSession = false
			session = nil
			clearSession = true
		}
	}

	if session != nil && session.Email != "" && !p.Validator(session.Email) {
		log.Printf("%s Permission Denied: removing session %s", remoteAddr, session)
		session = nil
		saveSession = false
		clearSession = true
	}

	if saveSession && session != nil {
		err := p.SaveSession(rw, req, session)
		if err != nil {
			log.Printf("%s %s", remoteAddr, err)
			return http.StatusInternalServerError
		}
	}

	if clearSession {
		p.ClearSessionCookie(rw, req)
	}

	if session == nil {
		session, err = p.CheckBasicAuth(req)
		if err != nil {
			log.Printf("%s %s", remoteAddr, err)
		}
	}

	if session == nil {
		return http.StatusForbidden
	}

	// At this point, the user is authenticated. proxy normally
	if p.PassBasicAuth {
		req.SetBasicAuth(session.User, p.BasicAuthPassword)
		req.Header["X-Forwarded-User"] = []string{session.User}
		if session.Email != "" {
			req.Header["X-Forwarded-Email"] = []string{session.Email}
		}
	}
	if p.PassUserHeaders {
		req.Header["X-Forwarded-User"] = []string{session.User}
		if session.Email != "" {
			req.Header["X-Forwarded-Email"] = []string{session.Email}
		}
	}
	if p.SetXAuthRequest {
		rw.Header().Set("X-Auth-Request-User", session.User)
		if session.Email != "" {
			rw.Header().Set("X-Auth-Request-Email", session.Email)
		}
	}
	if p.PassAccessToken && session.AccessToken != "" {
		req.Header["X-Forwarded-Access-Token"] = []string{session.AccessToken}
	}
	if session.Email == "" {
		rw.Header().Set("GAP-Auth", session.User)
	} else {
		rw.Header().Set("GAP-Auth", session.Email)
	}
	return http.StatusAccepted
}

func (p *OAuthProxy) CheckBasicAuth(req *http.Request) (*providers.SessionState, error) {
	if p.HtpasswdFile == nil {
		return nil, nil
	}
	auth := req.Header.Get("Authorization")
	if auth == "" {
		return nil, nil
	}
	s := strings.SplitN(auth, " ", 2)
	if len(s) != 2 || s[0] != "Basic" {
		return nil, fmt.Errorf("invalid Authorization header %s", req.Header.Get("Authorization"))
	}
	b, err := b64.StdEncoding.DecodeString(s[1])
	if err != nil {
		return nil, err
	}
	pair := strings.SplitN(string(b), ":", 2)
	if len(pair) != 2 {
		return nil, fmt.Errorf("invalid format %s", b)
	}
	if p.HtpasswdFile.Validate(pair[0], pair[1]) {
		log.Printf("authenticated %q via basic auth", pair[0])
		return &providers.SessionState{User: pair[0]}, nil
	}
	return nil, fmt.Errorf("%s not in HtpasswdFile", pair[0])
}
