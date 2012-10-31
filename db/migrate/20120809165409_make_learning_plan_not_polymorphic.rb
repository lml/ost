# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

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