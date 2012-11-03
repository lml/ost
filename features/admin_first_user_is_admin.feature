# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

Feature: The first created user is automatically an admin

  The first account created is automatically given admin privileges.
  Subsequent accounts do not automatically have admin privileges.
  
  Scenario: The first user created is automatically an admin
    Given that there are no users
    And   that there is a single user named "First User"
    Then  "First User" is an admin
    
  Scenario: Users after the first are not automatically admins
    Given that there are no users
    And   that there is a single user named "First User"
    And   that "First User" is an admin
    And   that there is a single user named "Second User"
    Then  "Second User" is not an admin
    
    