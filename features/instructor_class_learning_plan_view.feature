# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Instructors can view the Learning Plans for Classes they are teaching.

    Instructors can view the Learning Plan for Classes they are
    teaching.  This is done via the Learning Plan link on the
    Class show page.  The Learning Plan content includes Topics
    (which contain Resources and Exercises) and Assignments.
    Instructors can also preview Assignment distribution to
    Class Cohorts.

    The "Get Smart" Organization is offering two Courses:
        "Intro 101: Only the Easy Stuff"
        "Course 102: Time to Rethink Your Major"
    Classes for each of these Courses already exist.

    "Professor X" is an Instructor both Classes.

    "Intro 101: Only the Easy Stuff" has no Topics and no AssignmentPlans.

    "Course 102: Time to Rethink Your Major" has two Topics:
        "First Topic"   with no Resources and no Exercises
        "Second Topic"  with two Resources and two Exercises
    and two AssignmentPlans:
        "Homework One"  covering "First Topic"
        "Homework Two"  covering "First Topic" and "Second Topic"

    Background:
        Given instructor class learning plan view setup

    Scenario: Professor X views Learning Plan for Intro 101
        Given that I am logged in as "Professor X"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Intro 101"
        Then  I am taken to the "show" page for "Intro 101: Only the Easy Stuff" under "Get Smart"
        When  I click on "right_nav" "Learning Plan"
        Then  I am taken to the "show" page for "Learning Plan" under "Intro 101: Only the Easy Stuff"
        And   under "topics" I do not see "Resources"
        And   under "topics" I do not see "Exercises"
        And   under "assignments" I do not see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        
    Scenario: Professor X views Learning Plan for Course 102
        Given that I am logged in as "Professor X"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course 102"
        Then  I am taken to the "show" page for "Course 102: Time to Rethink Your Major" under "Get Smart"
        When  I click on "right_nav" "Learning Plan"
        Then  I am taken to the "show" page for "Learning Plan" under "Course 102: Time to Rethink Your Major"
        And   under "topics" "section containing First Topic" I see "0 Resources"
        And   under "topics" "section containing First Topic" I see "0 Exercises"
        And   under "topics" "section containing Second Topic" I see "2 Resources"
        And   under "topics" "section containing Second Topic" I see "2 Exercises"
        When  I double-click on "topics" "section containing First Topic"
        #And   screencapture "after_doubleclick_first"
        Then  under "topics" "section containing First Topic" "resources" I see "None"
        And   under "topics" "section containing First Topic" "exercises" I see "None"
        When  I double-click on "topics" "section containing Second Topic"
        #And   screencapture "after_doubleclick_second"
        Then  under "topics" "section containing Second Topic" "resources" I see "Resource One"
        And   under "topics" "section containing Second Topic" "resources" I see "Resource Two"
        And   under "topics" "section containing Second Topic" "exercises" I see "Concept One"
        And   under "topics" "section containing Second Topic" "exercises" I see "Concept Two"
        And   under "assignments" I see "Homework One"
        And   under "assignments" I see "Homework Two"
        When  I double-click on "assignments" "section containing Homework One"
        Then  under "assignments" "section containing Homework One" I see "First Topic"
        When  I double-click on "assignments" "section containing Homework Two"
        Then  under "assignments" "section containing Homework Two" I see "First Topic"
        Then  under "assignments" "section containing Homework Two" I see "Second Topic"

