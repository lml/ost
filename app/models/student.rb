class Student < ActiveRecord::Base
  attr_accessible :cohort_id, :is_auditing, :user_id
end
