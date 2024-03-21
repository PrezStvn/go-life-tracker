package models

type Workout struct {
    Movement    string  `json:"movement"`
    Weight      float64 `json:"weight"`
    Reps        int     `json:"reps"`
    Sets        int     `json:"sets"`
    RPE         float64 `json:"rpe"`
}

