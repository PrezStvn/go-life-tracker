package initializers

import (
	"database/sql"
	_ "github.com/lib/pq"

	"log"
	"os"

	"github.com/joho/godotenv"
)

func LoadEnvVariables() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}

var DB *sql.DB

func ConnectToDB() {
	var err error
	connStr := os.Getenv("DB")
	DB, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	
}