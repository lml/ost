class InitializeAssignmentPlanTags < ActiveRecord::Migration
  def up
    AssignmentPlan.find_each do |ap|
      # must use read_attribute because AssignmentPlan#exercise_tags no longer exists
      ap.tag_list = ap.read_attribute :exercise_tags
      ap.save!
    end
  end

  def down
    AssignmentPlan.find_each do |ap|
      # must use write_attribute because AssignmentPlan#exercise_tags= no longer exists
      ap.write_attribite :exercise_tags, ap.tag_list.to_s
      ap.tag_list = ""
      ap.save!
    end
  end
end
