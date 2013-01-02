# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Instructors can teach an existing Course

    A User who have been designated as an Instructor for a Course
    can choose to teach that course.
  
    The "Get Smart" Organization has two courses in the Course Catalog:
        "Intro 101: Only the Easy Stuff"
        "Nightmare 666: You Will Fail"
    User "Professor X" has been made an Instructor for Intro 101.
    User "John Doe" is a generic User.

    Background:
        Given instructor teach course setup

    Scenario: An Instructor chooses to teach an existing Course
        Given that I am logged in as "Professor X"
        When  I visit the main page
        And   I click on "course_catalog"
        Then  I am taken to the "index" page for "Course Catalog"
        When  I click on the "section containing Get Smart" "section containing Intro 101" "teach"
        Then  I am taken to the "new" page for "Class" under "Intro 101: Only the Easy Stuff"
        When  I enter "July 1, 2000" in the "klass_open_date" field
        When  I enter "August 1, 2000" in the "klass_start_date" field
        And   I enter "September 1, 2000" in the "klass_end_date" field
        And   I enter "October 1, 2000" in the "klass_close_date" field
        When  I click on "submit"
        Then  I am taken to the "show" page for "Intro 101: Only the Easy Stuff" under "Get Smart"

    Scenario: A non-Instructor attempts to teach an existing Course
        Given that I am logged in as "John Doe"
        When  I visit the main page
        And   I click on "course_catalog"
        Then  I am taken to the "index" page for "Course Catalog"
        When  I click on the "section containing Get Smart" "section containing Intro 101" "teach"
        Then  I am taken to the "index" page for "Course Catalog"
        And   I see a flash containing "permission"

    Scenario: An Instructor for one Course tries to teach another Course
        Given that I am logged in as "Professor X"
        When  I visit the main page
        And   I click on "course_catalog"
        Then  I am taken to the "index" page for "Course Catalog"
        When  I click on the "section containing Get Smart" "section containing Nightmare 666" "teach"
        Then  I am taken to the "index" page for "Course Catalog"
        And   I see a flash containing "permission"
