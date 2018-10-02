package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"runtime"
	"syscall"
	"time"

	"gopkg.in/gcfg.v1"

	"prm/com.omnicon.prm.library/lib_conf"
	"prm/com.omnicon.prm.service/handler"
	"prm/com.omnicon.prm.service/log"
	"prm/com.omnicon.prm.service/util"
)

// Variable utilizada para guardar el nombre del archivo de configuracion
// del servicio que se le pasa como parametro al iniciar la instancia
// var fileConfig = flag.String("fileconfig", "", "Nombre del archivo de configuracion")
var cfgConfig util.Config

func init() {
	// Se establece la zona horaria local a UTC para que al utilizar
	// los metodos de time.Parse o time.Unix cambie la fecha por la diferencia horaria
	fmt.Println("CAMILO MAIN ....................................................0")
	time.Local = time.UTC
}

func main() {
	fmt.Println("CAMILO MAIN ....................................................1")

	// Se utiliza para poder obtener el parametro del nombre del archivo
	flag.Parse()
	fmt.Println("CAMILO MAIN ....................................................2")

	// Se lee el archivo de configuración del servicio y se parsea en la variable cfgConfig
	err1 := gcfg.ReadFileInto(&cfgConfig, lib_conf.CONF_PREFIX)
	if err1 != nil {
		fmt.Println("CAMILO MAIN ....................................................3")

		panic(err1)
	}
	fmt.Println("CAMILO MAIN ....................................................4")

	// Se configura el log del servicio
	log.ConfigureLog(cfgConfig.Logs.LogPath, cfgConfig.Logs.LogName, cfgConfig.Logs.LogLevel, cfgConfig.Logs.LogTimer)
	fmt.Println("CAMILO MAIN ....................................................5")

	// Configura todos los cores posibles en el servidor donde se ejecute el servicio
	getSetUpCores()
	fmt.Println("CAMILO MAIN ....................................................6")

	// Print the GOGC variable
	printGOGCEnvVariable()
	fmt.Println("CAMILO MAIN ....................................................7")

	// Conexion al redis
	handleSignals()
	fmt.Println("CAMILO MAIN ....................................................8")

	handler.SetUpHandlers()
	fmt.Println("Frontal HTTP arrancado....")
	log.Info("Frontal HTTP arrancado....")
	fmt.Println("Escuchando en el puerto: ", cfgConfig.Service.Port)
	log.Info("Escuchando en el puerto: ", cfgConfig.Service.Port)

	err := http.ListenAndServe(":"+cfgConfig.Service.Port, nil)

	// Si se produce un error con el listener de la aplicacion, se imprimi- el error
	if err != nil {
		fmt.Print("Server failed: ", err.Error())
	}
}

// Funcion encargada de consultar el n-mero maximo de cores permitidos para trabajar
// en una determinada maquina y configurarlos en el servicio para que los pueda utilizar
// al momento de trabajar con goroutines
func getSetUpCores() {
	maxCPU := runtime.NumCPU()
	fmt.Println("Number max of CPUs", maxCPU)
	//runtime.GOMAXPROCS(cfgConfig.Service.Cpus)
	runtime.GOMAXPROCS(maxCPU)
	fmt.Printf("Number of GOMAXPROCS %v \n", maxCPU)
}

func printGOGCEnvVariable() {
	fmt.Println("GOGC set to:", os.Getenv("GOGC"))
}

// Escucha para el control cuando se baja el servicio
func handleSignals() {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	signal.Notify(c, syscall.SIGTERM)
	go func() {
		<-c
		fmt.Println("Shutdown Service")
		os.Exit(0)
	}()
}
