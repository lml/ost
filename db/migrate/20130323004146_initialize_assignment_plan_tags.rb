class InitializeAssignmentPlanTags < ActiveRecord::Migration
  def up
    AssignmentPlan.find_each do |ap|
      ap.tag_list = ap.exercise_tags
      ap.save!
    end
  end

  def down
    AssignmentPlan.find_each do |ap|
      ap.exercise_tags = ap.tag_list.join(', ');
      ap.tag_list = ""
      ap.save!
    end
  end
end
