class CreateLearningConditions < ActiveRecord::Migration
  def change
    create_table :learning_conditions do |t|
      t.integer :cohort_id

      t.timestamps
    end
  end
end
