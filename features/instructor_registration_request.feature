Feature: Instructors can handle pending Registration Requests for Classes they are teaching.

    Instructors can approve or reject pending Registration Requests for Classes
    they are teaching.  The is done throug the Class show page, where there is
    a link to a list of pending Registration Requests.

    The "Get Smart" Organization is offering three Courses:
        "Intro 101: Only the Easy Stuff"
        "Course 102: Time to Rethink Your Major"
        "Nightmare 666: You Will Fail"
    Classes for each of these Courses already exist.

    "Professor X" is an Instructor for all three Courses.

    "Intro 101" has two Sections ("Section Alpha" and "Section Beta") and no pending Registration Requests.

    "Course 102" has two Sections ("Section Alpha" and "Section Beta") and
    three pending Registration Request:
        User "Vito"   wants to register in "Section Alpha"
        User "Phoebe" wants to audit    in "Section Beta"
        User "Hubert" wants to register in "Section Beta"

    "Nightmare 666" has one Section ("Section Alpha") and two pending
    Registration Requests:
        User "Dameon" wants to register
        User "Oda"    wants to audit

    Background:
        Given instructor registration request setup
        
    Scenario: Professor X handles Registration Requests for Intro 101
        Given that I am logged in as "Professor X"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Intro 101"
        Then  I am taken to the "show" page for "Intro 101: Only the Easy Stuff" under "Get Smart"
        # And   screencapture "prof_x_show"
        And   in the "row containing Section Alpha" I see "0 Registered"
        And   in the "row containing Section Alpha" I see "0 Auditing"
        And   in the "row containing Section Alpha" I see "0 Pending"
        And   in the "row containing Section Beta" I see "0 Registered"
        And   in the "row containing Section Beta" I see "0 Auditing"
        And   in the "row containing Section Beta" I see "0 Pending"
        When  I click on "pending"
        Then  I am taken to the "index" page for "Registration Request" under "Intro 101: Only the Easy Stuff"
        # And   screencapture "prof_x_index"
        And   I do not see "Vito"
        And   I do not see "Dameon"
        And   I do not see "Oda"

    Scenario: Professor X handles Registration Requests for Course 102
        Given that I am logged in as "Professor X"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course 102"
        Then  I am taken to the "show" page for "Course 102: Time to Rethink Your Major" under "Get Smart"
        # And   screencapture "prof_x_show"
        And   in the "row containing Section Alpha" I see "0 Registered"
        And   in the "row containing Section Alpha" I see "0 Auditing"
        And   in the "row containing Section Alpha" I see "1 Pending"
        And   in the "row containing Section Beta" I see "0 Registered"
        And   in the "row containing Section Beta" I see "0 Auditing"
        And   in the "row containing Section Beta" I see "2 Pending"
        When  I click on "pending"
        Then  I am taken to the "index" page for "Registration Request" under "Course 102: Time to Rethink Your Major"
        # And   screencapture "prof_x_index"
        And   I see "Vito"
        And   I see "Phoebe"
        And   I see "Hubert"
        When  I click on "approve" under the "row containing Vito"
        Then  I am taken to the "index" page for "Registration Request" under "Course 102: Time to Rethink Your Major"
        And   I see a flash containing "Added Vito"
        When  I click on "reject" under the "row containing Phoebe"
        Then  I am taken to the "index" page for "Registration Request" under "Course 102: Time to Rethink Your Major"
        And   I see a flash containing "Rejected Phoebe"
        And   I see "Hubert"
        When  I click on "Class"
        Then  I am taken to the "show" page for "Course 102: Time to Rethink Your Major" under "Get Smart"
        And   in the "row containing Section Alpha" I see "1 Registered"
        And   in the "row containing Section Alpha" I see "0 Auditing"
        And   in the "row containing Section Alpha" I see "0 Pending"
        And   in the "row containing Section Beta" I see "0 Registered"
        And   in the "row containing Section Beta" I see "0 Auditing"
        And   in the "row containing Section Beta" I see "1 Pending"

    Scenario: Professor X handles Registration Requests for Course 102
        Given that I am logged in as "Professor X"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Nightmare 666"
        Then  I am taken to the "show" page for "Nightmare 666: You Will Fail" under "Get Smart"
        # And   screencapture "prof_x_show"
        And   I do not see "Section Alpha"
        And   I see "0 Registered"
        And   I see "0 Auditing"
        And   I see "2 Pending"
        When  I click on "pending"
        Then  I am taken to the "index" page for "Registration Request" under "Nightmare 666: You Will Fail"
        # And   screencapture "prof_x_index"
        And   I see "Dameon"
        And   I see "Oda"
        When  I click on "approve" under the "row containing Dameon"
        Then  I am taken to the "index" page for "Registration Request" under "Nightmare 666: You Will Fail"
        And   I see a flash containing "Added Dameon"
        When  I click on "approve" under the "row containing Oda"
        Then  I am taken to the "index" page for "Registration Request" under "Nightmare 666: You Will Fail"
        And   I see a flash containing "Added Oda"
        When  I click on "Class"
        Then  I am taken to the "show" page for "Nightmare 666: You Will Fail" under "Get Smart"
        And   I do not see "Section Alpha"
        And   I see "1 Registered"
        And   I see "1 Auditing"
        And   I see "0 Pending"

