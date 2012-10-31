# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Instructors can view the Classes they are teaching on the Dashboard.

    In addition to the other information availble on the Dashboard, Instructors
    can view a list of Classes they are teaching.  This list will also contain
    links to the Class show pages.

    The "Get Smart" Organization is offering three Courses:
        "Intro 101: Only the Easy Stuff"
        "Course 102: Time to Rethink Your Major"
        "Nightmare 666: You Will Fail"
    "Professor X" is not an Instuctor for any of these Courses.
    "Professor Y" is an Instructor for "Intro 101" only.
    "Professor Z" in an Instructor for all three Courses. 
    Classes for each of these Courses alreay exist.

    Background:
        Given instructor dashboard setup
        
    Scenario: Professor X visits the Dashboard
        Given that I am logged in as "Professor X"
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        And   I do not see "Intro 101"
        And   I do not see "Course 102"
        And   I do not see "Nightmare 666"

    Scenario: Professor Y visits the Dashboard and edits "Intro 101"
        Given that I am logged in as "Professor Y"
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        # And   screencapture "profY"
        And   I see "Intro 101"
        And   I do not see "Course 102"
        And   I do not see "Nightmare 666"
        When  I click on "Intro 101"
        Then  I am taken to the "show" page for "Intro 101: Only the Easy Stuff" under "Get Smart"

    Scenario: Professor Z visits the Dashboard and edits "Nightmare 666"
        Given that I am logged in as "Professor Z"
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        # And   screencapture "prof_z"
        And   I see "Intro 101"
        And   I see "Course 102"
        And   I see "Nightmare 666"
        When  I click on "Nightmare 666"
        Then  I am taken to the "show" page for "Nightmare 666: You Will Fail" under "Get Smart"


