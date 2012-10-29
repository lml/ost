Feature: Instructors can view the Learning Plans for Classes they are teaching.

    Instructors can view the Learning Plan for Classes they are
    teaching.  This is done via the Learning Plan link on the
    Class show page.  The Learning Plan content includes Topics
    (which contain Resources and Exercises) and Assignments.
    Instructors can also preview Assignment distribution to
    Class Cohorts.

    The "Get Smart" Organization is offering three Courses:
        "Intro 101: Only the Easy Stuff"
        "Course 102: Time to Rethink Your Major"
        "Nightmare 666: You Will Fail"
    Classes for each of these Courses already exist.

    "Professor X" is an Instructor all three Classes.

    "Intro 101" has two Sections ("Section Alpha" and "Section Beta")
    but no Students.

    "Course 102" has one Section ("Section Alpha") with the following 
    enrollment:
        Student "Vito"     is fully registered
        Student "Twila"    is auditing
        Student "Melissa"  is dropped

    "Nightmare 666" has two Sections ("Section Alpha" and "Section Beta") 
    with the following enrollments:
        "Section Alpha":
            Student "Dameon" is fully registered
            Student "Oda"    is fully registered
        "Section Beta":
            Student "Adrien" is auditing
            Student "Phoebe" is auditing
            Student "Hubert" is dropped

    Background:
        Given instructor class learning plan view setup

    Scenario: Professor X views Learning Plan for Intro 101
        Given that I am logged in as "Professor X"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Intro 101"
        Then  I am taken to the "show" page for "Intro 101: Only the Easy Stuff" under "Get Smart"
        # And   screencapture "prof_x_show"
        When  I click on "right_nav" "Learning Plan"
        # And   screencapture "prof_x_lp"
        Then  I am taken to the "show" page for "Learning Plan" under "Intro 101: Only the Easy Stuff"
        And   under "topics" I do not see "Resources"
        And   under "topics" I do not see "Exercises"

    Scenario: Professor X views Learning Plan for Course 102
        Given that I am logged in as "Professor X"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course 102"
        Then  I am taken to the "show" page for "Course 102: Time to Rethink Your Major" under "Get Smart"
        # And   screencapture "prof_x_show"
        When  I click on "right_nav" "Learning Plan"
        # And   screencapture "prof_x_lp"
        Then  I am taken to the "show" page for "Learning Plan" under "Course 102: Time to Rethink Your Major"
        And   under "topics" "section containing First Topic" I see "0 Resources"
        And   under "topics" "section containing First Topic" I see "0 Exercises"
        And   under "topics" "section containing Second Topic" I see "2 Resources"
        And   under "topics" "section containing Second Topic" I see "2 Exercises"
