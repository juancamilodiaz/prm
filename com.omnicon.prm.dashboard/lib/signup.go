package lib

import (
	"errors"

	"prm/com.omnicon.prm.dashboard/convert"
	"prm/com.omnicon.prm.dashboard/models"
)

func SignupUser(u *models.User) (int64, error) {
	var (
		err error
		msg string
	)

	if models.Users().Filter("email", u.Email).Exist() {
		msg = "was already regsitered input email address."
		return 0, errors.New(msg)
	}

	u.Password = convert.StrTo(u.Password).Md5()

	err = u.Insert()
	if err != nil {
		return 0, err
	}

	return u.Id, err
}

func ResetPassword(pEmail string) (string, error) {
	var (
		err error
		msg string
	)
	msg = "The email address is not registered."

	user := new(models.User)
	user.Email = pEmail

	if err := user.Read("Email"); err != nil {
		if err.Error() == "<QuerySeter> no row found" {
			err = errors.New(msg)
		}
		return "", err
	} else if user.Id < 1 {
		// No user
		return "", errors.New(msg)
	}

	newPassword := convert.GetRandomString(6)
	user.Password = convert.StrTo(newPassword).Md5()

	user.Update("password")
	if err != nil {
		return "", err
	}
	return newPassword, nil
}
