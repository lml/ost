# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class FeedbackCondition < ActiveRecord::Base
  belongs_to :learning_condition
  
  store :settings
  
  attr_accessible :learning_condition
  
  acts_as_numberable :container => :learning_condition
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    can_anything?(user)
  end

  def can_be_created_by?(user)
    can_anything?(user)
  end

  def can_be_updated_by?(user)
    can_anything?(user)
  end

  def can_be_destroyed_by?(user)
    can_anything?(user)
  end
  
  def can_be_sorted_by?(user)
    can_anything?(user)
  end
  
  def can_anything?(user)
    learning_condition.can_anything?(user)
  end

end
