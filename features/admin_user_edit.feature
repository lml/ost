Feature: Admins can edit an existing Users

  Admins have the ability to edit an existing User
  via the Admin Console.
  
  Scenario: An admin edits an existing User
    Given that there is a single user named "Joe Admin"
    Given that there is a single user named "User Alpha"
    And   that "Joe Admin" is an admin
    And   that "User Alpha" is not an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "user_list"
    Then  I am taken to the "index" page for "User"
    When  I click on "row containing Alpha" "edit_button"
    Then  I am taken to the "edit" page for "User Alpha"
    When  I click on "is_admin"
    And   I click on "submit"
    Then  I am taken to the "show" page for "User Alpha"
    And   "User Alpha" is an admin
