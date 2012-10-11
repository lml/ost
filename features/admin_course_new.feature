Feature: Admins can add a new Course to an existing Organization

  Admins have the ability to add a new Course to an existing Organization
  via the Admin Console.
  
  Scenario: An admin adds a new Course to an existing Organization.
    Given that there is a single user named "Joe Admin"
    And   that "Joe Admin" is an admin
    And   that there is a single organization named "Only Org"
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "organizations"
    Then  I am taken to the "index" page for "Organization"
    When  I click on "Only Org"
    Then  I am taken to the "show" page for "Only Org"
    When  I click on "new_course"
    Then  I am taken to the "new" page for "Course" under "Only Org"
    When  I enter "Intro 101: Only the Easy Stuff" in the "Name" field
    And   I enter "Intro 101" in the "Short name" field
    And   I enter "Blah blah blah words words words" in the "Description" field
    And   I enter "Every 3rd Tuesday" in the "Typically offered" field
    And   I click on "submit"
    Then  I am taken to the "show" page for "Intro 101: Only the Easy Stuff" under "Only Org"
    And   there is a single course named "Intro 101: Only the Easy Stuff"
    
  