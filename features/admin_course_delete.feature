# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Admins can delete an existing Course from an Organization

  Admins have the ability to delete an existing Course from an Organization
  via the Admin Console.
  
  Scenario: An admin deletes an existing Course to an Organization.
    Given that there is a single user named "Joe Admin"
    And   that "Joe Admin" is an admin
    And   that there is a single organization named "Only Org"
    And   that organization "Only Org" has a course named "Intro 101"
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "organizations"
    Then  I am taken to the "index" page for "Organization"
    When  I click on "Only Org"
    Then  I am taken to the "show" page for "Only Org"
    When  I click on "row containing Intro 101" "trash_button" "and confirm"
    Then  I am taken to the "show" page for "Only Org"
    And   there is no course named "Intro 101"
