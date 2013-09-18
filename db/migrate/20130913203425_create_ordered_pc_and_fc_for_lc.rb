class CreateOrderedPcAndFcForLc < ActiveRecord::Migration
  class LearningConditionPresentationCondition < ActiveRecord::Base
  end

  class LearningConditionFeedbackCondition < ActiveRecord::Base
  end

  class PresentationCondition < ActiveRecord::Base
  end

  class FeedbackCondition < ActiveRecord::Base
    self.inheritance_column = nil
  end

  def up
    create_table :learning_condition_presentation_conditions do |t|
      t.integer     :learning_condition_id
      t.integer     :presentation_condition_id
      t.integer     :number
      t.timestamps
    end

    add_index  :learning_condition_presentation_conditions, [:learning_condition_id],          name: "index_lcpcs_on_lc_id"
    add_index  :learning_condition_presentation_conditions, [:number, :learning_condition_id], name: "index_lcpcs_on_number_scoped", :unique => true

    create_table :learning_condition_feedback_conditions do |t|
      t.integer     :learning_condition_id
      t.integer     :feedback_condition_id
      t.integer     :number
      t.timestamps
    end

    add_index  :learning_condition_feedback_conditions, [:learning_condition_id],          name: "index_lcfcs_on_lc_id"
    add_index  :learning_condition_feedback_conditions, [:number, :learning_condition_id], name: "index_lcfcs_on_number_scoped", :unique => true

    LearningConditionPresentationCondition.reset_column_information
    PresentationCondition.reset_column_information
    LearningConditionFeedbackCondition.reset_column_information
    FeedbackCondition.reset_column_information
    FeedbackCondition.inheritance_column = nil

    LearningCondition.find_each do |lc|

      PresentationCondition.where{learning_condition_id == lc.id}.each do |pc|
        LearningConditionPresentationCondition.create! do |lcpc|
          lcpc.learning_condition_id      = pc.learning_condition_id
          lcpc.presentation_condition_id  = pc.id
          lcpc.number                     = pc.number
        end
      end

      FeedbackCondition.where{learning_condition_id == lc.id}.each do |fc|
        LearningConditionFeedbackCondition.create! do |lcfc|
          lcfc.learning_condition_id  = fc.learning_condition_id
          lcfc.feedback_condition_id  = fc.id
          lcfc.number                 = fc.number
        end
      end

    end

    remove_index  :presentation_conditions, name: "index_pcs_on_lc_id"
    remove_index  :presentation_conditions, name: "index_pcs_on_number_scoped"
    remove_column :presentation_conditions, :learning_condition_id
    remove_column :presentation_conditions, :number

    remove_index  :feedback_conditions, name: "index_fcs_on_lc_id"
    remove_index  :feedback_conditions, name: "index_feedback_conditions_on_number_scoped"
    remove_column :feedback_conditions, :learning_condition_id
    remove_column :feedback_conditions, :number

  end

  def down
    add_column :presentation_conditions, :learning_condition_id, :integer
    add_column :presentation_conditions, :number,                :integer
    add_index  :presentation_conditions, [:learning_condition_id],          name: "index_pcs_on_lc_id"
    add_index  :presentation_conditions, [:number, :learning_condition_id], name: "index_pcs_on_number_scoped", :unique => true

    add_column :feedback_conditions, :learning_condition_id, :integer
    add_column :feedback_conditions, :number,                :integer
    add_index  :feedback_conditions, [:learning_condition_id],          name: "index_fcs_on_lc_id"
    add_index  :feedback_conditions, [:number, :learning_condition_id], name: "index_fcs_on_number_scoped", :unique => true

    LearningConditionPresentationCondition.reset_column_information
    PresentationCondition.reset_column_information
    LearningConditionFeedbackCondition.reset_column_information
    FeedbackCondition.reset_column_information

    LearningConditionPresentationCondition.find_each do |lcpc|
      PresentationCondition.find(lcpc.presentation_condition_id) do |pc|
        pc.learning_condition_id = lcpc.learning_condition_id
        pc.number                = lcpc.number
        pc.save!
      end
    end

    LearningConditionFeedbackCondition.find_each do |lcfc|
      FeedbackCondition.find(lcfc.feedback_condition_id) do |fc|
        fc.learning_condition_id = lcfc.learning_condition_id
        fc.number                = lcfc.number
        fc.save!
      end
    end

    drop_table :learning_condition_presentation_conditions
    drop_table :learning_condition_feedback_conditions
  end
end
