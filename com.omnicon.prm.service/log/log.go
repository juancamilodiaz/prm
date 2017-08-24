// +build debug

package log

import (
	"fmt"
	"io"
	"log"
	"os"
	"time"
)

var (
	headerRequest string

	errorr *log.Logger
	warn   *log.Logger
	info   *log.Logger
	debug  *log.Logger
	timer  *log.Logger

	NivelDebug = 1
	NivelInfo  = 2
	NivelWarn  = 3
	NivelError = 4
	NivelTime  = 5
	NivelLog   = NivelDebug
)

func SetHeaderRequest(pHeader string) {
	headerRequest = pHeader
}

func Warn(v ...interface{}) {
	if NivelWarn >= NivelLog {
		warn.Output(2, fmt.Sprintln(v...))
	}
}

func Warnf(format string, v ...interface{}) {
	if NivelWarn >= NivelLog {
		warn.Output(2, fmt.Sprintf(format, v...))
	}
}

func Info(v ...interface{}) {
	if NivelInfo >= NivelLog {
		info.Output(2, fmt.Sprintln(v...))
	}
}

func Infof(format string, v ...interface{}) {
	if NivelInfo >= NivelLog {
		info.Output(2, fmt.Sprintf(format, v...))
	}
}

func Error(v ...interface{}) {
	if NivelError >= NivelLog {
		errorr.Output(2, fmt.Sprintln(v...))
	}
}

func Errorf(format string, v ...interface{}) {
	if NivelError >= NivelLog {
		errorr.Output(2, fmt.Sprintf(format, v...))
	}
}

func Debug(v ...interface{}) {
	if NivelDebug >= NivelLog {
		debug.Output(2, fmt.Sprintln(v...))
	}
}

func Debugf(format string, v ...interface{}) {
	if NivelDebug >= NivelLog {
		debug.Output(2, fmt.Sprintf(format, v...))
	}
}

func Timer(pOperacion string, pTime time.Time) {
	trace := pOperacion + " : " + time.Now().Sub(pTime).String()
	if NivelTime >= NivelLog {
		timer.Output(2, fmt.Sprintln(trace))
	}
}

/*
	Descripcion
		Funcion que se encarga de realizar la configuracion del servicio.
		- Define la salida de logs en fichero, inicializa las variables WARN, INFO, DEBUG.
	Parametros
		string :  logName, nombre del fichero de logs.
		string : timerLogName, identifica el nombre del fichero que contiene la salida de timer logs
	Retorna
		 err :  error en caso de no pueda cargar la configuracion del fichero config.ini o no encuentre
				la seccion logs en él.
*/
func ConfigureLog(logPath, logName string, logLevel int, timerLogName string) {

	fmt.Printf("Creating in path %v the logs %v, %v\n", logPath, logName, timerLogName)

	initLog(logPath, logName, logLevel, timerLogName)
}

/*
	Descripcion
		Funcion que se encarga de configurar la salida de logs en un fichero.
		- Inicializa las variables WARN, INFO, DEBUG.
	Parametros
		string :  path, identifica la carpeta destino del fichero que contendra la salida de debug logs.
		string : logName, identifica el nombre del fichero que contiene la salida de debug logs
*/
func initLog(logPath, logName string, logLevel int, timerLogName string) {

	var debugPath = logPath + logName
	var timerPath = logPath + timerLogName

	debugFile, err := os.OpenFile(debugPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalln("Failed to open log file", err)
	}

	timerFile, err := os.OpenFile(timerPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalln("Failed to open time log file", err)
	}

	multi := io.MultiWriter(debugFile, os.Stdout)
	// Para no imprimir en consola
	//multi := io.MultiWriter(debugFile)

	info = log.New(multi, "INFO: ", log.Ldate|log.Ltime|log.Lshortfile)
	warn = log.New(multi, "WARN: ", log.Ldate|log.Ltime|log.Lshortfile)
	errorr = log.New(multi, "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile)
	debug = log.New(multi, "DEBUG: ", log.Ldate|log.Ltime|log.Lshortfile)
	timer = log.New(timerFile, "TIME: ", log.Lshortfile)
}
