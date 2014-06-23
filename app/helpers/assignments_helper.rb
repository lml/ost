# Copyright 2011-2014 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.
require 'memoist'
module AssignmentsHelper
  extend Memoist
  def authority?
    @assignment.cohort.klass.is_educator?(present_user) ||
      Researcher.is_one?(present_user) ||
      present_user.is_administrator?
  end
  memoize :authority?
end
