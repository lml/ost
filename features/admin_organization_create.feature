Feature: Admins can create Organizations.

  Admins have the ability to create new Organization
  via the Admin Console.

  Scenario: An admin creates a new Organization
    Given that there is a single user named "Joe Admin"
    And   that "Joe Admin" is an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on the "Admin Console" link
    Then  I am taken to the "Administrator's Console" page
    When  I click on the "Organizations" link
    Then  I am taken to the "Organizations" page
    When  I click on the "New Organization" link
    Then  I am taken to the "new" page for "Organization"
    When  I enter "Awesome Org" in the "Name" field
    And   I select "Paris" for "Default time zone"
    And   I click the "Create Organization" button
    Then  I am taken to the "show" page for "Awesome Org"
    And   there is a single organization named "Awesome Org"
