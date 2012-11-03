# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class DropPercentSchedulers < ActiveRecord::Migration
  def up
    drop_table :percent_schedulers
    change_column :schedulers, :learning_condition_id, :integer, :null => false
    add_index :schedulers, :learning_condition_id
  end

  def down
    raise IllegalOperation
  end
end
