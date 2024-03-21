package models

import "time"


type Session struct {
    SessionId    int        `json:"session_id"`
    UserId       int        `json:"user_id"`
    SessionDate  time.Time  `json:"session_date"`
    Notes        string     `json:"notes,omitempty"` // Optional field
    ProgramId    *int       `json:"program_id,omitempty"` // Pointer to allow null
}

type SessionSubmission struct {
    UserId      int       `json:"-"`
    ProgramId   *int      `json:"program_id,omitempty"` // Use a pointer to allow nil or omitempty
    SessionDate time.Time `json:"session_date,omitempty"`
    Notes       string    `json:"notes,omitempty"`
    Workouts    []Workout `json:"workouts"`
}