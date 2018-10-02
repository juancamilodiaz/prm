package dao

import (
	"fmt"
	//"time"

	"prm/com.omnicon.prm.service/log"
	"upper.io/db.v3/lib/sqlbuilder"
	"upper.io/db.v3/mssql"
)

// Session class variable
var session sqlbuilder.Database

var settings = mssql.ConnectionURL{
	User:     "admin",
	Password: "admin",
	//Host:     "OMN77076",
	Host: "OMNdd77076", // MALO, para pruebas de no conexión
	//	Host:     "OMN4QFVNJ2",
	Database: "prm",
}

func GetSession() sqlbuilder.Database {
	fmt.Println("CAMILO DAOCONN ....................................................1")
	var err error
	var sess sqlbuilder.Database
	//for sess == nil {
	fmt.Println("CAMILO DAOCONN ....................................................2")
	sess, err = mssql.Open(settings)
	if err != nil {
		fmt.Println("CAMILO DAOCONN ....................................................3")
		log.Error(err)
		//time.Sleep(5 * time.Second)
		//sess = nil
	}
	//}
	fmt.Println("CAMILO DAOCONN ....................................................4")

	return sess
}

func ConnAvaible() bool {
	var err error
	var sess sqlbuilder.Database
	for sess == nil {
		sess, err = mssql.Open(settings)
		if err != nil {
			//log.Error(err)
			//time.Sleep(5 * time.Second)
			return false
		}
	}
	return true

}
