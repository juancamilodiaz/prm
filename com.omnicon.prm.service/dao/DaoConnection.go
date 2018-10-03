package dao

import (
	"fmt"

	gcfg "gopkg.in/gcfg.v1"
	"prm/com.omnicon.prm.library/lib_conf"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
	"upper.io/db.v3/lib/sqlbuilder"
	"upper.io/db.v3/mssql"
)

//Session class variable
var session sqlbuilder.Database

//configuration variable
var cfgConfig util.Config

/*var settings = mssql.ConnectionURL{
	User:     "admin",
	Password: "admin",
	Host:     "OMNdd77076", // MALO, para pruebas de no conexión
	//	Host:     "OMN4QFVNJ2",
	Database: "prm",
}*/

//function to deliver the configuration of the database
func ConfigDBConnection() mssql.ConnectionURL {
	return mssql.ConnectionURL{
		User:     cfgConfig.ConfigMSSQL.User,
		Password: cfgConfig.ConfigMSSQL.Password,
		Host:     cfgConfig.ConfigMSSQL.Host,
		Database: cfgConfig.ConfigMSSQL.Database,
	}
}

//lee el archivo de configuración del servicio y se parsea en la variable cfgConfig
func ReadFileIntoConfig() {
	err := gcfg.ReadFileInto(&cfgConfig, lib_conf.CONF_PREFIX)
	if err != nil {
		panic(err)
	}
}

//function to generate the connection to the database
func GetSession() sqlbuilder.Database {
	var err error
	var sess sqlbuilder.Database
	fmt.Println("Starting the connection to Database...")
	//Se lee el archivo de configuración
	ReadFileIntoConfig()
	fmt.Println("Trying to connect to Database...")
	sess, err = mssql.Open(ConfigDBConnection())
	if err != nil {
		fmt.Println("Error Trying to connect to Database, check the log file for more information.")
		log.Error(err)
	}
	fmt.Println("Success connection to Database...")
	return sess
}
