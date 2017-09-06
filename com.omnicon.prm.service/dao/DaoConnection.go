package dao

import (
	"time"

	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3/lib/sqlbuilder"
	"upper.io/db.v3/mssql"
)

// Session class variable
var session sqlbuilder.Database

var settings = mssql.ConnectionURL{
	User:     "admin",
	Password: "admin",
	Host:     "OMNCND5035B21\\SQLEXPRESS",
	Database: "master",
}

func GetSession() sqlbuilder.Database {
	var err error
	var sess sqlbuilder.Database
	for sess == nil {
		sess, err = mssql.Open(settings)
		if err != nil {
			log.Error(err)
			time.Sleep(5 * time.Second)
		}
	}
	return sess
}