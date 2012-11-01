# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class RemoveKlassIdFromLearningConditions < ActiveRecord::Migration
  def up
    remove_column :learning_conditions, :klass_id
  end

  def down
    add_column :learning_conditions, :klass_id, :integer
  end
end
