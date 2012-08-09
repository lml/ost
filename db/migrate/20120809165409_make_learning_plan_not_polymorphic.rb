class MakeLearningPlanNotPolymorphic < ActiveRecord::Migration
  def up
    remove_index :learning_plans, :name => 'learning_plannable_index'
    
    rename_column :learning_plans, :learning_plannable_id, :klass_id
    remove_column :learning_plans, :learning_plannable_type
    
    add_index :learning_plans, :klass_id
  end

  def down
    raise NotYetImplemented
  end
end