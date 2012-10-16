Feature: Admins can view the list of existing Users

  Admins have the ability to view the list of existing Users
  via the Admin Console.
  
  Scenario: An admin views the list of existing Users
    Given that there is a single user named "Joe Admin"
    Given that there is a single user named "User Alpha"
    Given that there is a single user named "User Beta"
    And   that "Joe Admin" is an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "user_list"
    Then  I am taken to the "index" page for "User"
    Then  I see "Joe"
    And   I see "Alpha"
    And   I see "Beta"
