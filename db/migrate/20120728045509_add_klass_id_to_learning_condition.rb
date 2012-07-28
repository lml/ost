class AddKlassIdToLearningCondition < ActiveRecord::Migration
  def change
    add_column :learning_conditions, :klass_id, :integer, :null => :false
    
    add_index :learning_conditions, :klass_id
    add_index :learning_conditions, :cohort_id
  end
end
