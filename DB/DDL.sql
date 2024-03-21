-- db/init.sql
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE training_programs (
    program_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sessions (
    session_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    program_id INTEGER, -- Allows NULL to enable sessions not linked to any program
    session_date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id), -- Assuming you have a users table
    FOREIGN KEY (program_id) REFERENCES training_programs(program_id) -- FK reference
);


CREATE TABLE movements (
    movement_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT -- Optional field for a description of the movement
);

CREATE TABLE workouts (
    workout_id SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL,
    movement_id INTEGER, -- Use if you have a movements table, otherwise replace with a text field
    weight DECIMAL NOT NULL,
    reps INTEGER NOT NULL,
    sets INTEGER NOT NULL,
    rpe DECIMAL(3, 1),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
    FOREIGN KEY (movement_id) REFERENCES movements(movement_id) -- Use if you have a movements table
);


CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW(); -- Set the updated_at column to the current date and time
    RETURN NEW; -- Return the updated record
END;
$$ language 'plpgsql';


CREATE TRIGGER update_users_modtime
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_sessions_modtime
BEFORE UPDATE ON sessions
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_workouts_modtime
BEFORE UPDATE ON workouts
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_training_programs_modtime
BEFORE UPDATE ON training_programs
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();



INSERT INTO movements (name, description) VALUES
('Deadlift', 'A weight training exercise where a loaded barbell or bar is lifted off the ground to the level of the hips, then lowered back to the ground.'),
('Sumo Deadlift', 'A variation of the deadlift with a wider stance, which reduces the range of motion and targets different muscles.'),
('Stiff-Legged Deadlift', 'A deadlift variation focusing more on the hamstrings, with legs kept straighter than the traditional deadlift.'),
('Romanian Deadlift', 'A variant of the deadlift performed with less knee bend and more hip hinge, emphasizing hamstring, glute, and lower back development.'),
('Dumbbell Deadlift', 'Perform the deadlift using dumbbells. Allows for a more natural hand position and individual arm work.'),
('Squat', 'A compound, full-body exercise that trains primarily the muscles of the thighs, hips and buttocks.'),
('Front Squat', 'Similar to the squat, but performed with the barbell in front of the body on the shoulders.'),
('Overhead Squat', 'A squat performed with the arms extended overhead, challenging for balance and flexibility, targeting the whole body.'),
('Split Squat', 'A variation of the squat where one leg is positioned forward with knee bent and foot flat on the ground while the other leg is positioned behind.'),
('Dumbbell Squat', 'Perform the squat using dumbbells held at the sides. This variation allows for a different weight distribution.'),
('Bench Press', 'An upper-body weight training exercise in which the trainee presses a weight upwards while lying on a weight training bench.'),
('Incline Bench Press', 'A variation of the bench press where the bench is set to a slight incline, targeting the upper chest.'),
('Decline Bench Press', 'A variation of the bench press performed with the bench set to a decline, targeting the lower chest.'),
('Close-Grip Bench Press', 'A bench press performed with a narrower grip, focusing more on the triceps.'),
('Dumbbell Bench Press', 'Perform the bench press using dumbbells. This allows for a greater range of motion and individual arm stabilization.'),
('Overhead Press', 'A weight training exercise performed by pressing a weight directly upwards until the arms are locked out overhead.'),
('Push Press', 'A variation of the overhead press that uses a slight leg drive to help move the weight, allowing for heavier lifts.'),
('Arnold Press', 'A variation of the dumbbell press invented by Arnold Schwarzenegger that starts with palms facing the body and rotates out as the weight is pressed.'),
('Dumbbell Overhead Press', 'Perform the overhead press using dumbbells. Useful for targeting each arm independently and ensuring balanced development.'),
('Barbell Row', 'A compound exercise that strengthens the back, shoulders, and biceps through the lifting of a barbell to the torso.'),
('Pendlay Row', 'A variation of the barbell row where the bar starts on the ground for each rep, requiring a stricter form and more explosive power.'),
('Dumbbell Row', 'Perform the row using a dumbbell. Allows for a greater range of motion and targets the back muscles effectively.'),
('Dumbbell Front Squat', 'Perform the front squat using dumbbells held at shoulder height, engaging the core and the front of the body.'),
('Dumbbell Romanian Deadlift', 'A deadlift variation using dumbbells, focusing on the hamstrings and glutes with a focus on balancing each side of the body.'),
('Dumbbell Split Squat', 'Perform the split squat holding dumbbells. This variation increases the exercise difficulty and improves balance.');
