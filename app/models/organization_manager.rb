class OrganizationManager < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  
  validate :organization_id, :presence => true
  validate :user_id, :presence => true, :uniqueness => {:scope => :organization_id}
  
  attr_accessible
end
