Feature: Admins can edit existing Organizations.

  Admins have the ability to edit an existing Organization
  via the Admin Console.  This can be done via the Edit link
  or via the Edit icon.

  Scenario: An admin edits an existing Organization using the Edit link
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
    When  I click on the "Edit" link
    Then  I am taken to the "edit" page for "Only Org"
    And   the "Name" field contains "Only Org"
    When  I enter "Renamed Org" in the "Name" field
    And   I click the "Update Organization" button
    Then  I am taken to the "show" page for "Renamed Org"
    And   there is a single organization named "Renamed Org"
    And   there is no organization named "Only Org"

    @javascript
    Scenario: An admin edits an existing Organization using the Edit icon
      Given that there is a single user named "Joe Admin"
      And   that there is a single organization named "Only Org"
      And   that "Joe Admin" is an admin
      And   that I am logged in as "Joe Admin"
      When  I visit the main page
      And   I click on the "Admin Console" link
      Then  I am taken to the "Administrator's Console" page
      When  I click on the "Organizations" link
      Then  I am taken to the "index" page for "Organization"
      When  I mouse over the edit icon for "Only Org"
      # When  I click on the edit icon for "Only Org"
      # Then  I am taken to the "edit" page for "Only Org"
      # And   the "Name" field contains "Only Org"
      # When  I enter "Renamed Org" in the "Name" field
      # And   I click the "Update Organization" button
      # Then  I am taken to the "show" page for "Renamed Org"
      # And   there is a single organization named "Renamed Org"
      # And   there is no organization named "Only Org"
