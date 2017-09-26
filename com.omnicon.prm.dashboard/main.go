package main

import (
	"github.com/astaxie/beego"

	_ "prm/com.omnicon.prm.dashboard/conf/inits"
	_ "prm/com.omnicon.prm.dashboard/routers"
)

func main() {
	beego.Run()
}
