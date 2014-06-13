# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

class UserSettings < ActiveRecord::Base
  store :settings

  store_typed_accessor  :settings, :boolean, :skip_answer_lockin_message

  attr_accessible :skip_answer_lockin_message, :user_id

  after_initialize :supply_missing_values

  def self.for (user)
    if user
      find_or_create_by_user_id(:user_id => user.id)
    else
      nil
    end
  end

  def supply_missing_values
    self.skip_answer_lockin_message ||= false
  end


end
