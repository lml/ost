class RemoveTypeFromFeedbackCondition < ActiveRecord::Migration
  def change
    remove_column :learning_conditions, :type
  end
end
