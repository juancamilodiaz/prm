package lib_conf

import (
	"flag"
	"fmt"
	"os"
	"strings"
)

func init() {
	flag.StringVar(&CONF_PREFIX, "fileConfig", ".", "Is necessary to spcify the application configuration directory: -fileConfig ./myconf")
	//flag.Parse()
	setLoaderConf()
}

var CONF_PREFIX string = ""

const CONF_PREFIX_NAME = "fileConfig"

func setLoaderConf() {
	for _, k := range os.Args {
		if strings.Contains(k, CONF_PREFIX_NAME) {
			CONF_PREFIX = k[strings.Index(k, CONF_PREFIX_NAME)+len(CONF_PREFIX_NAME)+1:]
		}
	}
	fmt.Println("Set loader configuration directory to: ", CONF_PREFIX)
}
