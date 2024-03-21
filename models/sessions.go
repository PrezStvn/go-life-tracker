package models

import "time"


type Session struct {
    SessionID    int        `json:"session_id"`
    UserID       int        `json:"user_id"`
    SessionDate  time.Time  `json:"session_date"`
    Notes        string     `json:"notes,omitempty"` // Optional field
    ProgramID    *int       `json:"program_id,omitempty"` // Pointer to allow null
}

type SessionSubmission struct {
    UserID      int       `json:"user_id"`
    ProgramID   *int      `json:"program_id,omitempty"` // Use a pointer to allow nil
    Notes       string    `json:"notes,omitempty"`
    Workouts    []Workout `json:"workouts"`
}