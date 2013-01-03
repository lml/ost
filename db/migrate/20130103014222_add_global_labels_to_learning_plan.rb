class AddGlobalLabelsToLearningPlan < ActiveRecord::Migration
  def change
    add_column :learning_plans, :test_exercise_tags,    :string, :default => ""
    add_column :learning_plans, :nontest_exercise_tags, :string, :default => ""
  end
end
