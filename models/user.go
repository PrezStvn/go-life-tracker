package models


type User struct {
    UserID       int       `json:"user_id"`
    Username     string    `json:"username"`
    PasswordHash string    `json:"-"` // The "-" tag means this field will be ignored by the json encoder
    }

