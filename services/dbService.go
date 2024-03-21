package services

import (
	"database/sql"

	_ "github.com/lib/pq" // PostgreSQL driver
	"github.com/prezstvn/workoutTracker/initializers"
	"github.com/prezstvn/workoutTracker/models"
)

func GetUserByUsername(db *sql.DB, username string) (*models.User, error) {
	var user models.User
	err := db.QueryRow("SELECT user_id, username, password_hash FROM users WHERE username = $1", username).Scan(&user.UserID, &user.Username, &user.PasswordHash)
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func getMovementIdByName(name string) (int, error) {
	sqlQuery := "SELECT movement_id FROM movements WHERE name = $1"
	var movementId int
	err := initializers.DB.QueryRow(sqlQuery, name).Scan(&movementId)
	if err != nil {
		return 0, err
	}

	return movementId, nil
}

func addWorkout(workout models.Workout, sessionId int) error {
	movementId, err := getMovementIdByName(workout.Movement)
	if err != nil {
		return err
	}

	sqlQuery := "INSERT INTO workouts(session_id, movement_id, weight, reps, sets, rpe) VALUES ($1, $2, $3, $4, $5, $6)"

	_, err1 := initializers.DB.Exec(sqlQuery, sessionId, movementId, workout.Weight, workout.Reps, workout.Sets, workout.RPE)
	if err1 != nil {
		return err1
	}
	return nil
}

func  CreateSession(session *models.SessionSubmission) (error) {
    // Start a transaction
    tx, err := initializers.DB.Begin()
    if err != nil {
        return  err
    }

    // Insert the session and get its ID
    var sessionID int
    err = tx.QueryRow("INSERT INTO sessions (user_id, program_id, notes) VALUES ($1, $2, $3) RETURNING session_id",
        session.UserID, session.ProgramID, session.Notes).Scan(&sessionID)
    if err != nil {
        tx.Rollback()
        return err
    } 

    // Insert each workout, attributing to the session ID
    for _, workout := range session.Workouts {
        err := addWorkout(workout, sessionID)
        if err != nil {
            tx.Rollback()
            return err
        }
    }

    // Commit the transaction
    return tx.Commit()
}