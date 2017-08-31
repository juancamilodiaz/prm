package db

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"strconv"

	_ "github.com/denisenkom/go-mssqldb"
)

var (
	debug          = flag.Bool("debug", true, "enable debugging")
	password       = flag.String("password", "admin", "the database password")
	port      *int = flag.Int("port", 1433, "the database port")
	server         = flag.String("server", "OMNCND5035B21\\SQLEXPRESS", "the database server")
	user           = flag.String("user", "admin", "the database user")
	serverSPN      = flag.String("ServerSPN", "MSSQLSvc/"+*server+":"+strconv.Itoa(*port), "the server SPN label")
)

func Connect() *sql.DB {

	flag.Parse()

	if *debug {
		fmt.Printf(" password:%s\n", *password)
		fmt.Printf(" port:%d\n", *port)
		fmt.Printf(" server:%s\n", *server)
		fmt.Printf(" user:%s\n", *user)
		fmt.Printf(" serverSPN:%s\n", *serverSPN)
	}

	connString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d", *server, *user, *password, *port)
	//connString := fmt.Sprintf("server=%s;ServerSPN=%s", *server, *serverSPN)
	if *debug {
		fmt.Printf(" connString:%s\n", connString)
	}
	conn, err := sql.Open("mssql", connString)
	if err != nil {
		log.Fatal("Open connection failed:", err.Error())
	}
	defer conn.Close()
	stmt, err := conn.Prepare("select 1, 'abc'")
	if err != nil {
		log.Fatal("Prepare failed:", err.Error())
	}
	defer stmt.Close()

	row := stmt.QueryRow()
	var somenumber int64
	var somechars string
	err = row.Scan(&somenumber, &somechars)
	if err != nil {
		log.Fatal("Scan failed:", err.Error())
	}
	fmt.Printf("somenumber:%d\n", somenumber)
	fmt.Printf("somechars:%s\n", somechars)

	fmt.Printf("bye\n")

	return conn
}
