Feature: Instructors can view the Student enrollment for Classes they are teaching.

    Instructors can view the Student enrollment of Classes they are
    teaching.  The total number of registered and auditing Students
    should be available, as well as a complete list of Students and
    their statuses by Section.

    The "Get Smart" Organization is offering three Courses:
        "Intro 101: Only the Easy Stuff"
        "Course 102: Time to Rethink Your Major"
        "Nightmare 666: You Will Fail"
    Classes for each of these Courses already exist.

    "Professor X" is an Instructor for "Intro 101".
    "Professor Y" is an Instructor for "Course 102".
    "Professor Z" in an Instructor for "Nightmare 666".

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
        Given instructor enrollment scenario setup
        
    Scenario: Professor X views enrollment for Intro 101
        Given that I am logged in as "Professor X"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Intro 101"
        Then  I am taken to the "show" page for "Intro 101: Only the Easy Stuff" under "Get Smart"
        # And   screencapture "prof_x_show"
        And   in the "row containing Section Alpha" I see "0 Registered"
        And   in the "row containing Section Alpha" I see "0 Auditing"
        And   in the "row containing Section Beta" I see "0 Registered"
        And   in the "row containing Section Beta" I see "0 Auditing"
        When  I click on "registered"
        Then  I am taken to the "index" page for "Student" under "Intro 101: Only the Easy Stuff"
        # And   screencapture "prof_x_index"
        And   I do not see "Section Alpha"
        And   I do not see "Section Beta"
        And   I do not see "REGISTERED"
        And   I do not see "AUDITING"
        And   I do not see "DROPPED"

    Scenario: Professor Y views enrollment for Course 102
        Given that I am logged in as "Professor Y"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course 102"
        Then  I am taken to the "show" page for "Course 102: Time to Rethink Your Major" under "Get Smart"
        # And   screencapture "prof_y_show"
        And   I do not see "Section Alpha"
        And   I see "1 Registered"
        And   I see "1 Auditing"
        When  I click on "auditing"
        Then  I am taken to the "index" page for "Student" under "Course 102: Time to Rethink Your Major"
        # And   screencapture "prof_y_index"
        And   I do not see "Section Alpha"
        And   in the "row containing Vito" I see "REGISTERED"
        And   in the "row containing Twila" I see "AUDITING"
        And   in the "row containing Melissa" I see "DROPPED"

    Scenario: Professor Z views enrollment for Nightmare 666
        Given that I am logged in as "Professor Z"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Nightmare 666"
        Then  I am taken to the "show" page for "Nightmare 666: You Will Fail" under "Get Smart"
        # And   screencapture "prof_z_show"
        And   in the "row containing Section Alpha" I see "2 Registered"
        And   in the "row containing Section Alpha" I see "0 Auditing"
        And   in the "row containing Section Beta" I see "0 Registered"
        And   in the "row containing Section Beta" I see "2 Auditing"
        When  I click on "registered"
        Then  I am taken to the "index" page for "Student" under "Nightmare 666: You Will Fail"
        # And   screencapture "prof_z_index"
        And   I see "Section Alpha"
        And   I see "Section Beta"
        And   in the "row containing Dameon" I see "REGISTERED"
        And   in the "row containing Oda" I see "REGISTERED"
        And   in the "row containing Adrien" I see "AUDITING"
        And   in the "row containing Phoebe" I see "AUDITING"
        And   in the "row containing Hubert" I see "DROPPED"
