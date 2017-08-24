package util

// Config estructura utilizada para guardar los datos del archivo
// de configuración del servicio conf-1.ini
type Config struct {
	Service Service
	Logs    Logs
}

// Service estructura que guarda los datos de la sección service
// del archivo de configuración del servicio consumer-1.ini
type Service struct {
	Port       string
	Cpus       int
	Cpuprofile string
	Memprofile string
}

// Rethink estructura que guarda los datos de la seccion de conexion a rethink
// del archivo de configuracion del comparador
type MSSQL struct {
	Host          string
	DataBaseName  string
	TableName     string
	IndexName     string
	ValueForIndex string
}

// Logs estructura utilizada para guardar los datos del archivo
// config.ini para la configuración de los logs
type Logs struct {
	LogPath         string
	LogName         string
	LogLevel        int // LevelDebug = 1,	LevelInfo  = 2,	LevelWarn  = 3,	LevelError = 4 , LevelDebug = 5 o superior(desactiva el log)
	LogDsStatistics int
	LogTimer        string
}
