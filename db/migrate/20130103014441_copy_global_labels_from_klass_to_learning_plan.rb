class CopyGlobalLabelsFromKlassToLearningPlan < ActiveRecord::Migration
  def up
    Klass.find_each do |klass|
      klass.learning_plan.test_exercise_tags    = klass.test_exercise_tags
      klass.learning_plan.nontest_exercise_tags = klass.nontest_exercise_tags

      klass.test_exercise_tags    = ""
      klass.nontest_exercise_tags = ""

      klass.learning_plan.save!
      klass.save!
    end
  end

  def down
    Klass.find_each do |klass|
      klass.test_exercise_tags    = klass.learning_plan.test_exercise_tags
      klass.nontest_exercise_tags = klass.learning_plan.nontest_exercise_tags

      klass.learning_plan.test_exercise_tags    = ""
      klass.learning_plan.nontest_exercise_tags = ""

      klass.save!
      klass.learning_plan.save!
    end
  end
end
