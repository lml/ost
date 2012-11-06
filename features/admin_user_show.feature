# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Admins can view an existing User

  Admins have the ability to view an existing User
  via the Admin Console.
  
  Scenario: An admin views an existing User
    Given that there is a single user named "Joe Admin"
    Given that there is a single user named "User Alpha"
    And   that "Joe Admin" is an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "user_list"
    Then  I am taken to the "index" page for "User"
    When  I click on "row containing Alpha" "show_button"
    Then  I am taken to the "show" page for "User Alpha"