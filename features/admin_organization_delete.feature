# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Admins can delete an existing Organization

  Admins have the ability to delete an existing Organization
  via the Admin Console.
  
  Scenario: An admin deletes an existing Organization
    Given that there is a single user named "Joe Admin"
    And   that there is a single organization named "Only Org"
    And   that "Joe Admin" is an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "organizations"
    Then  I am taken to the "index" page for "Organization"
    When  I click on "row containing Only Org" "trash_button" "and confirm"
    Then  I am taken to the "index" page for "Organization"
    And   there is no organization named "Only Org"