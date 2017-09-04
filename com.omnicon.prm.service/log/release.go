// +build !debug

package log

func Warn(v ...interface{}) {
}

func Warnf(format string, v ...interface{}) {
}

func Info(v ...interface{}) {
}

func Infof(format string, v ...interface{}) {
}

func Error(v ...interface{}) {
}

func Errorf(format string, v ...interface{}) {
}

func Debug(v ...interface{}) {
}

func Debugf(format string, v ...interface{}) {
}

func ConfigureLog(logPath, logName string, logLevel int, timerLogName string) {
}
