# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class SiteLicense < ActiveRecord::Base
  attr_accessible :title, :body
  
  def latest?
    SiteLicense.where{created_at.gt Time.now}.none?
  end
  
  def any_agreements?
    User.where{created_at.gt my{created_at}}.any?
  end
  
  def self.latest
    SiteLicense.order{created_at.desc}.first
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    true
  end

  def can_be_created_by?(user)
    user.is_administrator?
  end

  def can_be_updated_by?(user)
    user.is_administrator? && !any_agreements?
  end

  def can_be_destroyed_by?(user)
    user.is_administrator? && !any_agreements?
  end
end
