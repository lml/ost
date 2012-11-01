# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: Admins can edit existing Organizations.

  Admins have the ability to edit an existing Organization
  via the Admin Console.  This can be done by the Edit link
  or by the Edit icon.

  Scenario: An admin edits an existing Organization using the Edit link
    Given that there is a single user named "Joe Admin"
    And   that there is a single organization named "Only Org"
    And   that "Joe Admin" is an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "organizations"
    Then  I am taken to the "index" page for "Organization"
    When  I click on "Only Org"
    Then  I am taken to the "show" page for "Only Org"
    When  I click on "edit_organization"
    Then  I am taken to the "edit" page for "Only Org"
    And   the "Name" field contains "Only Org"
    When  I enter "Renamed Org" in the "Name" field
    And   I click on "submit"
    Then  I am taken to the "show" page for "Renamed Org"
    And   there is a single organization named "Renamed Org"
    And   there is no organization named "Only Org"

    Scenario: An admin edits an existing Organization using the Edit icon
      Given that there is a single user named "Joe Admin"
      And   that there is a single organization named "Only Org"
      And   that "Joe Admin" is an admin
      And   that I am logged in as "Joe Admin"
      When  I visit the main page
      And   I click on "admin_console"
      Then  I am taken to the "admin console" page
      When  I click on "organizations"
      When  I click on "row containing Only Org" "edit_button"
      Then  I am taken to the "edit" page for "Only Org"
      And   the "Name" field contains "Only Org"
      When  I enter "Renamed Org" in the "Name" field
      And   I click on "submit"
      Then  I am taken to the "show" page for "Renamed Org"
      And   there is a single organization named "Renamed Org"
      And   there is no organization named "Only Org"
