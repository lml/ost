Feature: Admins can show an existing Organization.

  Admins have the ability to show an existing Organization
  via the Admin Console.

  Scenario: An admin shows an existing Organization
    Given that there is a single user named "Joe Admin"
    And   that there is a single organization named "Only Org"
    And   that "Joe Admin" is an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on the "Admin Console" link
    Then  I am taken to the "Administrator's Console" page
    When  I click on the "Organizations" link
    Then  I am taken to the "index" page for "Organization"
    When  I click on the "Only Org" link
    Then  I am taken to the "show" page for "Only Org"
    And   I see "Name"
    And   I see "Default Time Zone"
    And   I see "Courses"
