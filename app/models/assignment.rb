class Assignment < ActiveRecord::Base
  attr_accessible :ends_at, :introduction, :is_group_work_allowed, :is_open_book, :is_ready, :is_test, :learning_plan_id, :name, :starts_at
end
