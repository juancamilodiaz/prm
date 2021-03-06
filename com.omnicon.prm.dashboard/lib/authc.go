package lib

import (
	"errors"
	"strings"
	"time"

	"prm/com.omnicon.prm.dashboard/convert"
	"prm/com.omnicon.prm.dashboard/models"
)

/*
 Get authenticated user and update logintime
*/
func Authenticate(email string, password string) (user *models.User, err error) {
	msg := "invalid email or password."
	email = strings.ToLower(email)
	user = &models.User{Email: email}

	if err := user.Read("Email"); err != nil {
		if err.Error() == "<QuerySeter> no row found" {
			err = errors.New(msg)
		}
		return user, err
	} else if user.Id < 1 {
		// No user
		return user, errors.New(msg)
	} else if user.Password != convert.StrTo(password).Md5() {
		// No matched password
		return user, errors.New(msg)
	} else {
		user.Lastlogintime = time.Now()
		user.Update("Lastlogintime")
		return user, nil
	}
}

func AuthenticateSession(pSessionState string) (user *models.User, err error) {
	msg := "invalid session."
	//	sessionState := ""

	//values := strings.Split(pSessionState, "session_state")
	/*if len(pSessionState) > 0 {
		sessionState = values[1]
	}*/

	if pSessionState == "" {
		// No user
		return user, errors.New(msg)
	}
	user = &models.User{SessionState: pSessionState}
	user.Id = 1

	return user, nil
}
