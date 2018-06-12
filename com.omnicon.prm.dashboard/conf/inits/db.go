package inits

import (
	_ "time"

	_ "prm/com.omnicon.prm.dashboard/models"

	_ "github.com/astaxie/beego"
	_ "github.com/astaxie/beego/orm"

	_ "github.com/lib/pq"
)

func init() {
	/*
		dbname := "default"
		runmode := beego.AppConfig.String("runmode")
		datasource := beego.AppConfig.String("datasource")

		switch runmode {
		case "prod":
			orm.RegisterDriver("postgres", orm.DRPostgres)
			orm.RegisterDataBase(dbname, "postgres", datasource, 30)
			orm.SetMaxIdleConns(dbname, 100)
			orm.SetMaxOpenConns(dbname, 100)
		case "dev":
			orm.Debug = true
			fallthrough
		default:
			orm.RegisterDriver("postgres", orm.DRPostgres)
			orm.RegisterDataBase(dbname, "postgres", datasource, 30)
			orm.SetMaxIdleConns(dbname, 100)
			orm.SetMaxOpenConns(dbname, 100)
		}

		orm.DefaultTimeLoc = time.FixedZone("Pacific", -5*3600)

		force, verbose := false, true
		err := orm.RunSyncdb(dbname, force, verbose)
		if err != nil {
			panic(err)
		}
	*/
	// orm.RunCommand()
}
