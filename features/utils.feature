Feature: Scenario utility functions work properly

  Background:
    Given that there are no users
    Given that there is a single user named "First User"

  Scenario: Querying an existing user by unique full name
    Given that there is a single user named "John Doe"
  	Then  there is a single user named "John Doe"

  Scenario: Querying an non-existent user by full name
    Given that there is no user named "John Doe"
  	Then  there is no user named "John Doe"
    	  
	Scenario: Querying an existing organziation by unique name
	  Given that there is a single organization named "EZ U"
	  Then  there is a single organization named "EZ U"
	  
	Scenario: Querying a non-existent organization by name
	  Given that there is no organization named "EZ U"
	  Then  there is no organization named "EZ U"

	Scenario: Querying an existing course by unique name
	  Given that there is a single course named "Intro 101"
	  Then  there is a single course named "Intro 101"
	  
	Scenario: Querying a non-existent course by name
	  Given that there is no course named "Intro 101"
	  Then  there is no course named "Intro 101"

	Scenario: Querying an existing class by unique course name
	  Given that there is a single class named "Intro 101"
	  Then  there is a single class named "Intro 101"

	Scenario: Querying a non-existent class by course unqiue name
	  Given that there is no class named "Intro 101"
	  Then  there is no class named "Intro 101"

  Scenario: Logging in as a user
    Given that I am logged in as "Aard Vark"
    Then  I am logged in as "Aard Vark"

  Scenario: Logging out 1
    Given that I am logged out
    Then  I am logged out

  Scenario: Logging out 2
    Given that I am logged in as "Aard Vark"
    When  I log out
    Then  I am logged out
    
  Scenario: Time travel
    Given that I am logged in as "First User"
    When  I time travel to "Dec 25, 2012" "UTC"
    And   cron jobs are run
    And   I refresh the page
    Then  I see "Dec 25, 2012"
