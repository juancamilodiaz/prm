package dao

import (
	"fmt"

	gcfg "gopkg.in/gcfg.v1"
	"prm/com.omnicon.prm.library/lib_conf"
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
	Host:     "OMNINFPRM",
	Database: "prm",
}*/

//ConfigDBConnection function to deliver the configuration of the database
func ConfigDBConnection() mssql.ConnectionURL {
	return mssql.ConnectionURL{
		User:     cfgConfig.ConfigMSSQL.User,
		Password: cfgConfig.ConfigMSSQL.Password,
		Host:     cfgConfig.ConfigMSSQL.Host,
		Database: cfgConfig.ConfigMSSQL.Database,
	}
}

//ReadFileIntoConfig lee el archivo de configuracion del servicio y se parsea en la variable cfgConfig
func ReadFileIntoConfig() {
	err := gcfg.ReadFileInto(&cfgConfig, lib_conf.CONF_PREFIX)
	if err != nil {
		fmt.Println(err)
		panic(err)
	}
}

//GetSession function to generate the connection to the database
func GetSession() sqlbuilder.Database {
	var err error
	var sess sqlbuilder.Database
	//log.Debug("Starting the connection to Database...")

	/*Se lee el archivo de configuración*/
	ReadFileIntoConfig()
	//log.Debug("Trying to connect to Database...")
	sess, err = mssql.Open(ConfigDBConnection())
	if err != nil {
		//	log.Error(err)
		return nil
	}
	//log.Debug("Success connection to Database...")
	return sess
}
