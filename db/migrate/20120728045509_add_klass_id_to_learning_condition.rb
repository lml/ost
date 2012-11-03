# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddKlassIdToLearningCondition < ActiveRecord::Migration
  def change
    add_column :learning_conditions, :klass_id, :integer, :null => :false
    
    add_index :learning_conditions, :klass_id
    add_index :learning_conditions, :cohort_id
  end
end
