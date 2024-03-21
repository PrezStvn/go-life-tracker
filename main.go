package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/prezstvn/workoutTracker/handlers"
	"github.com/prezstvn/workoutTracker/initializers"
	"github.com/prezstvn/workoutTracker/middleware"
	"net/http"
)

func init() {
	initializers.LoadEnvVariables()
	initializers.ConnectToDB()
}
func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})
	r.POST("/register", handlers.Register) // Adjust handler function if necessary
	r.POST("/login", handlers.Login)
	r.POST("/workouts", middleware.AuthMiddleware(), handlers.PostSession)
	fmt.Println("backend running")
	r.Run()
	//initializers.DB.Close()
}
