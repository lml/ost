Feature: Admins have admin and research toolboxes

  After logging in as an admin, there should be special links available for
  administrative research-oriented tasks.  These links should be available 
  on every page.
  
  Background:
    Given that there is a single user named "Joe Admin"
    And   that "Joe Admin" is an admin

  Scenario: Admin has admin and research toolbox links
    Given that I am logged in as "Joe Admin"
    When  I visit the main page
    Then  I should see an "Admin Console" link
    And   I should see a "Research Console" link
    When  I click on "dashboard"
    Then  I should see an "Admin Console" link
    And   I should see a "Research Console" link