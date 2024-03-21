package handlers

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/prezstvn/workoutTracker/initializers"
	"github.com/prezstvn/workoutTracker/services"
	"golang.org/x/crypto/bcrypt"
)

func Register(c *gin.Context) {
	//create struct to hold request body
	var body struct {
		Username string
		Password string
	}
	//bind request body vars to struct
	if c.Bind(&body) != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to read body",
		})
		return
	}

	//Hash Password
	hashword, err := bcrypt.GenerateFromPassword([]byte(body.Password), 10)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to hash password",
		})
		return
	}
	fmt.Println(string(hashword))
	sqlQuery := "INSERT INTO users (username, password_hash) VALUES ($1, $2)"

	_, err = initializers.DB.Exec(sqlQuery, body.Username, string(hashword))
	if err != nil {
		log.Printf("Failed to create user: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Failed to create user",
		})
		return //necessary for some reason after sending response
	}

	//success
	c.JSON(http.StatusOK, gin.H{
		"message": "User successfully registered!",
	})
}

func Login(c *gin.Context) {

	var loginRequest struct {
		Username string
		Password string
	}

	if c.Bind(&loginRequest) != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to read body",
		})
		return
	}

	// Retrieve user and hashed password from database based on req.Username
	// This is a simplified example. In practice, use database/sql to query your database.
	user, err := services.GetUserByUsername(initializers.DB, loginRequest.Username)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Failed to retrieve User",
		})
		return
	}

	// Verify password
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(loginRequest.Password)); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to login, incorrect credentials",
		})
		return
	}

	// Generate token (JWT or session token), omitted for brevity
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": user.UserId,
		"exp": time.Now().Add(time.Hour * 24).Unix(),
	})

	tokenString, err := token.SignedString([]byte(os.Getenv("SECRET")))

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "failed to create Token",
		})
		return
	}
	//the code below sets and returns a cookie and a token(a bit redundant)
	c.SetSameSite(http.SameSiteLaxMode)
	c.SetCookie("Authorization", tokenString, 3600*24*7, "", "", false, true)

	// Respond with token and success message
	c.JSON(http.StatusOK, gin.H{
		"token": tokenString,
	})
}
