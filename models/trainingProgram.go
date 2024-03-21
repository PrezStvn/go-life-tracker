package models

import (
	"time"
)

type TrainingProgram struct {
    ProgramId   int       `json:"program_id"`
    Name        string    `json:"name"`
    Description string    `json:"description,omitempty"` // Optional; omitempty omits the field if empty
    CreatedAt   time.Time `json:"created_at"`
    UpdatedAt   time.Time `json:"updated_at"`
}

// TrainingProgramSubmission represents the payload for submitting new or updated training programs.
type TrainingProgramSubmission struct {
    Name        string     `json:"name"`
    Description string     `json:"description,omitempty"`
    }