Feature: Admins can add an Instructor to an existing Course

  Admins have the ability to add an Instructor to an existing Course
  via the Admin Console.
  
  @javascript
  Scenario: An admin adds an Instructor to an existing Course
    Given that there is a single user named "Joe Admin"
    And   that "Joe Admin" is an admin
    And   that there is a single user named "Professor X"
    And   that "Professor X" is not an admin
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
    When  I click on "Intro 101"
    Then  I am taken to the "show" page for "Intro 101" under "Only Org"
    And   I do not see the "Add an instructor" dialog
    When  I click on "add_instructor"
    Then  I see the "Add an instructor" dialog
    When  I enter "X" in the "Search for:" field
    And   I click on "dialog" "search"
    Then  I see "Professor"
    And   screencapture "before_click"
    When  I click on "dialog" "list_row" "add" 
    Then  I see "Added"
    When  I click on "dialog" "close"
    Then  I do not see the "Add an instructor" dialog
    And   I am on the "show" page for "Intro 101" under "Only Org"
    And   I see a "Professor X" link
    And   "Professor X" is an instructor for "Intro 101"
    