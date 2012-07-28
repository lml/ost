class RemoveKlassIdFromLearningConditions < ActiveRecord::Migration
  def up
    remove_column :learning_conditions, :klass_id
  end

  def down
    add_column :learning_conditions, :klass_id, :integer
  end
end
