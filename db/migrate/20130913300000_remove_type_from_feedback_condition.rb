class RemoveTypeFromFeedbackCondition < ActiveRecord::Migration
  def change
    remove_column :feedback_conditions, :type
  end
end
