class FixAanIndexFeedbackCondition < ActiveRecord::Migration
  def up
    add_index     :feedback_conditions, [:number, :learning_condition_id], :unique => true, :name => "index_feedback_conditions_on_number_scoped"
  end

  def down
    remove_index  :feedback_conditions, :name => "index_feedback_conditions_on_number_scoped"
  end
end
