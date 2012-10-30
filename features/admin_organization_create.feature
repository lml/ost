Feature: Admins can create Organizations.

  Admins have the ability to create new Organization
  via the Admin Console.

  Scenario: An admin creates a new Organization
    Given that there is a single user named "Joe Admin"
    And   that "Joe Admin" is an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "organizations"
    Then  I am taken to the "index" page for "Organization"
    When  I click on "new_organization"
    Then  I am taken to the "new" page for "Organization"
    When  I enter "Awesome Org" in the "Name" field
    And   I select "Paris" for "Default time zone"
    And   I click on "submit"
    Then  I am taken to the "show" page for "Awesome Org"
    And   there is a single organization named "Awesome Org"
