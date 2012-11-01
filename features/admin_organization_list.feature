# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Admins can view the list of existing Organizations

  Admins have the ability to view the list of existing Organizations
  via the Admin Console.
  
  Scenario: An admin views the list of existing Organizations
    Given that there is a single user named "Joe Admin"
    And   that there is a single organization named "Org One"
    And   that there is a single organization named "Org Two"
    And   that "Joe Admin" is an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "organizations"
    Then  I am taken to the "index" page for "Organization"
    Then  I see "Org One"
    And   I see "Org Two"
    
    