# References:
#
#   http://stackoverflow.com/questions/1386490/manually-set-updated-at-in-rails

class MoveFreeResponsesIntoNewForm < ActiveRecord::Migration
  def up
    ActiveRecord::Base.record_timestamps = false

    StudentExercise.find_each do |se|
      next if se.free_response.nil?
      tfr = TextFreeResponse.new(:student_exercise_id => se.id,
                                 :content => se.free_response)
      tfr.created_at = se.created_at
      tfr.updated_at = se.created_at
      tfr.save!
    end

    ActiveRecord::Base.record_timestamps = true
  end

  def down
    TextFreeResponse.find_each do |tfr| 
      # A non nil old free response means this TFR was created above
      tfr.destroy if !tfr.student_exercise.free_response.nil?
    end
  end
end
