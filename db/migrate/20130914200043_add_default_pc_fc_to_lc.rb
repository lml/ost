class AddDefaultPcFcToLc < ActiveRecord::Migration
  class LearningConditionDefaultPresentationCondition < ActiveRecord::Base
  end

  class LearningConditionDefaultFeedbackCondition < ActiveRecord::Base
  end

  def up
    create_table :learning_condition_default_presentation_conditions do |t|
      t.integer :learning_condition_id
      t.integer :presentation_condition_id
      t.timestamps
    end

    add_index :learning_condition_default_presentation_conditions, [:learning_condition_id], name: "index_lcdpcs_on_lc_id_scoped", unique: true

    create_table :learning_condition_default_feedback_conditions do |t|
      t.integer :learning_condition_id
      t.integer :feedback_condition_id
      t.timestamps
    end

    add_index :learning_condition_default_feedback_conditions, [:learning_condition_id], name: "index_lcdfcs_on_lc_id_scoped", unique: true

    LearningConditionDefaultPresentationCondition.reset_column_information
    LearningConditionDefaultFeedbackCondition.reset_column_information

    PresentationCondition.reset_column_information
    FeedbackCondition.reset_column_information

    LearningCondition.find_each do |lc|

      dpc = PresentationCondition.default_presentation_condition
      dpc.save!

      LearningConditionDefaultPresentationCondition.create! do |lcdpc|
        lcdpc.learning_condition_id     = lc.id
        lcdpc.presentation_condition_id = dpc.id
      end

      dfc = FeedbackCondition.default_feedback_condition
      dfc.save!

      LearningConditionDefaultFeedbackCondition.create! do |lcdfc|
        lcdfc.learning_condition_id = lc.id
        lcdfc.feedback_condition_id = dfc.id
      end
    end
  end

  def down
    drop_table :learning_condition_default_presentation_conditions
    drop_table :learning_condition_default_feedback_conditions
  end
end
