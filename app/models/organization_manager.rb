# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class OrganizationManager < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  
  validates :organization_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :organization_id}
  
  attr_accessible
end
