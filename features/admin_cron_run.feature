Feature: Admins can run cron tasks

  Admins have the ability to run cron tasks
  via the Admin Console.
  
  Scenario: An admin runs cron tasks
    Given that there is a single user named "Joe Admin"
    And   that "Joe Admin" is an admin
    And   that I am logged in as "Joe Admin"
    When  I visit the main page
    And   I click on "admin_console"
    Then  I am taken to the "admin console" page
    When  I click on "run_cron_tasks"
    Then  I am taken to the "admin console" page
    And   I see "Ran cron tasks"
