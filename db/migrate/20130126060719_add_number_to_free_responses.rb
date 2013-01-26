class AddNumberToFreeResponses < ActiveRecord::Migration
  def change
    add_column :free_responses, :number, :integer
    add_index :free_responses, [:number, :student_exercise_id], :unique => true, :name => "index_free_responses_on_number_scoped"
  end
end
