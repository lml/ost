class SetDefaultReceivesErrorNoticesValue < ActiveRecord::Migration
  def up
    User.find_each do |user|
      user.receives_error_notices = false
      user.save!
    end
  end

  def down
    User.find_each do |user|
      user.receives_error_notices = nil
      user.save!
    end
  end
end
