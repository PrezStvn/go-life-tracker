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
('deadlift', 'A weight training exercise where a loaded barbell or bar is lifted off the ground to the level of the hips, then lowered back to the ground.'),
('sumodeadlift', 'A variation of the deadlift with a wider stance, which reduces the range of motion and targets different muscles.'),
('stiffleggeddeadlift', 'A deadlift variation focusing more on the hamstrings, with legs kept straighter than the traditional deadlift.'),
('romaniandeadlift', 'A variant of the deadlift performed with less knee bend and more hip hinge, emphasizing hamstring, glute, and lower back development.'),
('dumbbelldeadlift', 'Perform the deadlift using dumbbells. Allows for a more natural hand position and individual arm work.'),
('squat', 'A compound, full-body exercise that trains primarily the muscles of the thighs, hips and buttocks.'),
('frontsquat', 'Similar to the squat, but performed with the barbell in front of the body on the shoulders.'),
('overheadsquat', 'A squat performed with the arms extended overhead, challenging for balance and flexibility, targeting the whole body.'),
('splitsquat', 'A variation of the squat where one leg is positioned forward with knee bent and foot flat on the ground while the other leg is positioned behind.'),
('dumbbellsquat', 'Perform the squat using dumbbells held at the sides. This variation allows for a different weight distribution.'),
('benchpress', 'An upper-body weight training exercise in which the trainee presses a weight upwards while lying on a weight training bench.'),
('inclinebenchpress', 'A variation of the bench press where the bench is set to a slight incline, targeting the upper chest.'),
('declinebenchpress', 'A variation of the bench press performed with the bench set to a decline, targeting the lower chest.'),
('pausesquat', 'A variation of the squat that pauses at the bottom of the squat, allowing the stretch reflex to dissapate before exiting the hole'),
('closegripbenchpress', 'A bench press performed with a narrower grip, focusing more on the triceps.'),
('dumbbellbenchpress', 'Perform the bench press using dumbbells. This allows for a greater range of motion and individual arm stabilization.'),
('overheadpress', 'A weight training exercise performed by pressing a weight directly upwards until the arms are locked out overhead.'),
('pushpress', 'A variation of the overhead press that uses a slight leg drive to help move the weight, allowing for heavier lifts.'),
('arnoldpress', 'A variation of the dumbbell press invented by Arnold Schwarzenegger that starts with palms facing the body and rotates out as the weight is pressed.'),
('dumbbelloverheadpress', 'Perform the overhead press using dumbbells. Useful for targeting each arm independently and ensuring balanced development.'),
('barbellrow', 'A compound exercise that strengthens the back, shoulders, and biceps through the lifting of a barbell to the torso.'),
('pendlayrow', 'A variation of the barbell row where the bar starts on the ground for each rep, requiring a stricter form and more explosive power.'),
('chestsupportedrow', 'A variation of the row that puts the torso in a supported position, taking emphasis away from the lower back and maintaining posture'),
('dumbbellrow', 'Perform the row using a dumbbell. Allows for a greater range of motion and targets the back muscles effectively.'),
('dumbbellfrontsquat', 'Perform the front squat using dumbbells held at shoulder height, engaging the core and the front of the body.'),
('dumbbellromaniandeadlift', 'A deadlift variation using dumbbells, focusing on the hamstrings and glutes with a focus on balancing each side of the body.'),
('dumbbellsplitsquat', 'Perform the split squat holding dumbbells. This variation increases the exercise difficulty and improves balance.');