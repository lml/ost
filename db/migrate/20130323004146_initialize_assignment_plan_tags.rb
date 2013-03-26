class InitializeAssignmentPlanTags < ActiveRecord::Migration
  def up
    AssignmentPlan.find_each do |ap|
      # must use read_attribute to read value directly from table,
      # not from the new AssignmentPlan#exercise_tags method!
      ap.tag_list = ap.read_attribute :exercise_tags
      ap.save!
    end
  end

  def down
    AssignmentPlan.find_each do |ap|
      # must use read_attribute to write value directly from table,
      # not to the new AssignmentPlan#exercise_tags= method!
      ap.write_attribite :exercise_tags, ap.tag_list.to_s
      ap.tag_list = ""
      ap.save!
    end
  end
end
