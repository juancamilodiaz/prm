package panics

import (
	"fmt"
	"runtime"
	"time"
)

/*
	Descripcion:
    Captura el panic provocado y mostrar un stack trace.panic.go
*/
func CatchPanic(functionName string, params ...string) {
	r := recover()
	if r != nil {
		t := time.Now()
		msg := fmt.Sprintf("%s PANIC at %s : PANIC Defered recover: %v. With params: %v.\n", t, functionName, r, params)
		fmt.Println(msg)
		// Capture the stack trace
		buf := make([]byte, 10000)
		runtime.Stack(buf, false)
		msg = fmt.Sprintf("PANIC Stack Trace at %s : %s\n", functionName, string(buf))
		fmt.Println(msg)
	}
}
