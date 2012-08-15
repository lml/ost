# Copyright (c) 2011 Rice University.  All rights reserved.

require 'singleton'

class AnonymousUser
  include Singleton
  
  def can_read?(resource)
    resource.can_be_read_by?(self)
  end
  
  def can_create?(resource)
    false
  end
  
  def can_update?(resource)
    false
  end
    
  def can_destroy?(resource)
    false
  end

  def can_vote_on?(resource)
    false
  end
  
  def can_sort?(resource)
    false
  end
  
  def can_read_children?(resource, children_symbol)
    resource.children_can_be_read_by?(self, children_symbol)
  end

  def is_anonymous?
    true
  end

  def is_disabled?
    false
  end

  def is_administrator?
    false
  end
  
  def is_researcher?
    false
  end

  def is_visitor?
    false
  end

  # Necessary if an anonymous user ever runs into an Exception
  # or else the developer email doesn't work
  def username
    'anonymous'
  end
    
  # Just so we can never get mixed up with this and an active record
  def id
    nil
  end
  
end
