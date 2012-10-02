Feature: Admins can delete an existing Course from an Organization

  Admins have the ability to delete an existing Course from an Organization
  via the Admin Console.
  
  @javascript
  Scenario: An admin deletes an existing Course to an Organization.
    Given that there is a single user named "Joe Admin"
    And   that "Joe Admin" is an admin
    And   that there is a single organization named "Only Org"
    And   that organization "Only Org" has a course named "Intro 101"
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on the "Admin Console" link
    Then  I am taken to the "admin console" page
    When  I click on the "Organizations" link
    Then  I am taken to the "index" page for "Organization"
    When  I click on the "Only Org" link
    Then  I am taken to the "show" page for "Only Org"
    When  I click on the delete icon for "Intro 101" and "confirm"
    Then  I am taken to the "show" page for "Only Org"
    And   there is no course named "Intro 101"
