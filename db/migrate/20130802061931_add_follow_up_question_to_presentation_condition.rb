class AddFollowUpQuestionToPresentationCondition < ActiveRecord::Migration
  def change
    add_column :presentation_conditions, :follow_up_question, :string, default: nil
  end
end
