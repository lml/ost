# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Admins can edit an existing Course

  Admins have the ability to edit an existing Course
  via the Admin Console.
  
  Scenario: An admin edits an existing Course.
    Given that there is a single user named "Joe Admin"
    And   that "Joe Admin" is an admin
    And   that there is a single organization named "Only Org"
    And   that organization "Only Org" has a course named "Intro 101: Only the Easy Stuff"
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "organizations"
    Then  I am taken to the "index" page for "Organization"
    When  I click on "Only Org"
    Then  I am taken to the "show" page for "Only Org"
    And   I click on "row containing Intro 101: Only the Easy Stuff" "edit_button"
    Then  I am taken to the "edit" page for "Intro 101: Only the Easy Stuff" under "Only Org"
    When  I enter "Intro 101: Only the Hard Stuff" in the "Name" field
    And   I click on "submit"
    Then  I am taken to the "show" page for "Intro 101: Only the Hard Stuff" under "Only Org"
    And   there is a single course named "Intro 101: Only the Hard Stuff"
    And   there is no course named "Intro 101: Only the Easy Stuff"
