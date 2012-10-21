Feature: Admins can sign in as an existing User

  Admins have the ability to sign in as an existing User
  via the Admin Console.
  
  Scenario: An admin signs in as an existing User
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
    When  I click on "sign_in_as"
    Then  I am taken to the "index" page for "Home"
    And   I am logged in as "User Alpha"
