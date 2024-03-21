------------------------------Go Life Tracker-----------------------------------------

Go Life Tracker is initially conceived as a robust platform for tracking weightlifting and workout sessions, aimed at individuals keen on monitoring and optimizing their physical training regimen. The project, in its current form, focuses on providing detailed insights into workouts, enabling users to log exercises, sets, reps, and monitor progress over time.

However, the vision for Go Life Tracker extends far beyond the realm of physical fitness. The ultimate goal is to evolve the platform into a holistic life tracker, incorporating features that allow users to manage and analyze various aspects of their personal health and wellbeing, including meals, mood, mental health, and other key factors that contribute to overall wellness.

Features-

Detailed Workout Tracking: 
    Log every detail of your workouts, including specific exercises, weights lifted, sets, and reps, with options to note your rate of perceived exertion (RPE) and progress over time.
User Authentication: 
    A secure authentication system for managing user profiles and personal data.
Future Enhancements: 
    Planned features to track nutritional intake, daily mood, mental health assessments, and other wellbeing metrics, all aimed at providing a 360-degree view of personal health.

Technologies- 

Backend: 
    Built with Go and the Gin framework, chosen for their efficiency and ease of API development.
Database: 
    Utilizes PostgreSQL, offering robust, reliable data storage capabilities.
Authentication: 
    Employs JWT for secure authentication, ensuring user data is protected and sessions are managed securely.



Getting Started-

To set up Go Life Tracker for local development and testing, you will need to have Go, PostgreSQL, and Git installed on your machine. Follow the steps below to get the application running:

Installation-

Clone the repository:
    git clone https://github.com/PrezStvn/go-life-tracker.git
    cd go-life-tracker
Set up the PostgreSQL database:
    Create a database named life_tracker.
    Execute the SQL commands provided in DDL.sql to set up the database schema.
Configure environment variables:
    Duplicate .env.example to .env and fill in your database connection details and JWT secret key.


Contributing

As Go Life Tracker is in the process of broadening its feature set, contributions are particularly valuable at this stage. Whether you're interested in contributing code, suggesting new features, or providing feedback on usability, your input is highly welcome.

License-

Go Life Tracker is open source under the MIT License, allowing for wide use, modification, and sharing within the bounds of this permissive license. - see LICENSE.md for details