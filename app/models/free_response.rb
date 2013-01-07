class FreeResponse < ActiveRecord::Base

  belongs_to :student_exercise

  mount_uploader :attachment, FreeResponseUploader

  attr_accessible :attachment, :content, :content_type, :student_exercise_id
end
