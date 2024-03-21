package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/prezstvn/workoutTracker/models"
	"github.com/prezstvn/workoutTracker/services"
)

func PostWorkoutSession(c *gin.Context) {
	var session models.SessionSubmission

	// userID from JWT middleware
	if userID, exists := c.Get("userID"); exists {
		session.UserID = userID.(int)
	} else {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	if err := c.BindJSON(&session); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Could not read workout"})
		return
	}

	// Insert workout into the database, using workout.UserID to attribute it to the user
	c.JSON(http.StatusOK, gin.H{"message": "Workout logged successfully"})
}

func PostSession(c *gin.Context) {
	var req models.SessionSubmission
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Failed to read request"})
		return
	}

	value, exists := c.Get("userID") // Assume middleware has set this
	if !exists {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Could not identify User",
		})
	}
	//type assertion required
	userID, ok := value.(int)
	if !ok {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Could not identify User",
		})
	}

	req.UserID = userID
	
	// Create the session in the database and retrieve the generated SessionID
	err := services.CreateSession(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create session"})
		return
	}


	c.JSON(http.StatusCreated, gin.H{"message": "Session and workouts created successfully"})
}
