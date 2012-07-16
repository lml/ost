class RegistrationRequest < ActiveRecord::Base
  attr_accessible :is_auditing, :section_id, :user_id
end
