# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Assignments are properly distributed to Students and in Instructor Previews.

    Background:
        Given assignment distribution 1 Section 1 Cohort 100% setup

    Scenario: Professor X previews assignment distribution for Course One.
        Given that I am logged in as "Professor X"
        When  I visit the main page
        When  I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        When  I click on "right_nav" "Learning Plan"
        Then  I am taken to the "show" page for "Learning Plan" under "Course One"
        When  I click on "Preview assignments"
        Then  I am taken to the "preview assignments" page for "Learning Plan" under "Course One"
        And   under "section containing Homework One"   "section containing Cohort One" I see "Topic One Ex 0"
        And   under "section containing Homework One"   "section containing Cohort One" I see "Topic One Ex 1"
        And   under "section containing Homework One"   "section containing Cohort One" I see "Topic One Ex 2"
        And   under "section containing Homework Two"   "section containing Cohort One" I see "Topic Two Ex 0"
        And   under "section containing Homework Two"   "section containing Cohort One" I see "Topic Two Ex 1"
        And   under "section containing Homework Two"   "section containing Cohort One" I see "Topic Two Ex 2"
        And   under "section containing Homework Three" "section containing Cohort One" I see "Topic Three Ex 0"
        And   under "section containing Homework Three" "section containing Cohort One" I see "Topic Three Ex 1"
        And   under "section containing Homework Three" "section containing Cohort One" I see "Topic Three Ex 2"
        And   under "section containing Homework Four"  "section containing Cohort One" I see "Topic Four Ex 0"
        And   under "section containing Homework Four"  "section containing Cohort One" I see "Topic Four Ex 1"
        And   under "section containing Homework Four"  "section containing Cohort One" I see "Topic Four Ex 2"

    Scenario: C1S1CH1R Student receives notifications for and can view assignments at the appropriate times.
        Given that I am logged in as "C1S1CH1R Student"
        And   I time travel to "Sep 1, 2012 5:50am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   I see "No assignments yet!"
        And   under "assignments" I do not see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        And   there are no emails for "C1S1CH1R Student"
        When  I time travel to "Sep 1, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are emails for "C1S1CH1R Student"
        And   under "assignments" I see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        When  I click on "Homework One"
        Then  I am taken to the "show" page for "Homework One" under "Course One"
        And   under "exercises" I see "Topic One Ex 0"
        And   under "exercises" I see "Topic One Ex 1"
        And   under "exercises" I see "Topic One Ex 2"
        When  I time travel to "Sep 2, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are emails for "C1S1CH1R Student"
        And   under "assignments" I see "Homework One"
        And   under "assignments" I see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        When  I click on "Homework Two"
        Then  I am taken to the "show" page for "Homework Two" under "Course One"
        And   under "exercises" I see "Topic Two Ex 0"
        And   under "exercises" I see "Topic Two Ex 1"
        And   under "exercises" I see "Topic Two Ex 2"
        When  I time travel to "Sep 3, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are emails for "C1S1CH1R Student"
        And   under "assignments" I see "Homework One"
        And   under "assignments" I see "Homework Two"
        And   under "assignments" I see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        When  I click on "Homework Three"
        Then  I am taken to the "show" page for "Homework Three" under "Course One"
        And   under "exercises" I see "Topic Three Ex 0"
        And   under "exercises" I see "Topic Three Ex 1"
        And   under "exercises" I see "Topic Three Ex 2"
        When  I time travel to "Sep 4, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are emails for "C1S1CH1R Student"
        And   under "assignments" I see "Homework One"
        And   under "assignments" I see "Homework Two"
        And   under "assignments" I see "Homework Three"
        And   under "assignments" I see "Homework Four"
        When  I click on "Homework Four"
        Then  I am taken to the "show" page for "Homework Four" under "Course One"
        And   under "exercises" I see "Topic Four Ex 0"
        And   under "exercises" I see "Topic Four Ex 1"
        And   under "exercises" I see "Topic Four Ex 2"

    Scenario: C1S1CH1A receives notifications for and can view assignments at the appropriate times.
        Given that I am logged in as "C1S1CH1A Student"
        And   I time travel to "Sep 1, 2012 5:50am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   I see "No assignments yet!"
        And   under "assignments" I do not see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        And   there are no emails for "C1S1CH1A Student"
        When  I time travel to "Sep 1, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are emails for "C1S1CH1A Student"
        And   under "assignments" I see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        When  I click on "Homework One"
        Then  I am taken to the "show" page for "Homework One" under "Course One"
        And   under "exercises" I see "Topic One Ex 0"
        And   under "exercises" I see "Topic One Ex 1"
        And   under "exercises" I see "Topic One Ex 2"
        When  I time travel to "Sep 2, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are emails for "C1S1CH1A Student"
        And   under "assignments" I see "Homework One"
        And   under "assignments" I see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        When  I click on "Homework Two"
        Then  I am taken to the "show" page for "Homework Two" under "Course One"
        And   under "exercises" I see "Topic Two Ex 0"
        And   under "exercises" I see "Topic Two Ex 1"
        And   under "exercises" I see "Topic Two Ex 2"
        When  I time travel to "Sep 3, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are emails for "C1S1CH1A Student"
        And   under "assignments" I see "Homework One"
        And   under "assignments" I see "Homework Two"
        And   under "assignments" I see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        When  I click on "Homework Three"
        Then  I am taken to the "show" page for "Homework Three" under "Course One"
        And   under "exercises" I see "Topic Three Ex 0"
        And   under "exercises" I see "Topic Three Ex 1"
        And   under "exercises" I see "Topic Three Ex 2"
        When  I time travel to "Sep 4, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are emails for "C1S1CH1A Student"
        And   under "assignments" I see "Homework One"
        And   under "assignments" I see "Homework Two"
        And   under "assignments" I see "Homework Three"
        And   under "assignments" I see "Homework Four"
        When  I click on "Homework Four"
        Then  I am taken to the "show" page for "Homework Four" under "Course One"
        And   under "exercises" I see "Topic Four Ex 0"
        And   under "exercises" I see "Topic Four Ex 1"
        And   under "exercises" I see "Topic Four Ex 2"

    Scenario: C1S1CH1D receives no notifications for and cannot view assignments.
        Given that I am logged in as "C1S1CH1D Student"
        And   I time travel to "Sep 1, 2012 5:50am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   under "assignments" I do not see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        And   there are no emails for "C1S1CH1D Student"
        When  I time travel to "Sep 1, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are no emails for "C1S1CH1D Student"
        And   under "assignments" I do not see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        When  I time travel to "Sep 2, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are no emails for "C1S1CH1D Student"
        And   under "assignments" I do not see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        When  I time travel to "Sep 3, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are no emails for "C1S1CH1D Student"
        And   under "assignments" I do not see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
        When  I time travel to "Sep 4, 2012 6:05am" "UTC"
        Given that there are no emails
        When  cron jobs have been run
        When  I visit the main page
        And   I click on "dashboard"
        Then  I am taken to the "index" page for "Dashboard"
        When  I click on "Course One"
        Then  I am taken to the "show" page for "Course One" under "Organization One"
        And   there are no emails for "C1S1CH1D Student"
        And   under "assignments" I do not see "Homework One"
        And   under "assignments" I do not see "Homework Two"
        And   under "assignments" I do not see "Homework Three"
        And   under "assignments" I do not see "Homework Four"
