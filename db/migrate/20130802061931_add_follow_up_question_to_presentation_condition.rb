class AddFollowUpQuestionToPresentationCondition < ActiveRecord::Migration
  def change
    add_column :presentation_conditions, :follow_up_question, :string
    add_column :presentation_conditions, :apply_follow_up_question_to_tests, :boolean, default: false
  end
end
