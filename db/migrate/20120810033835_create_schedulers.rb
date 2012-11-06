# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateSchedulers < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.text :settings
      t.integer :learning_condition_id
      t.string :type

      t.timestamps
    end
  end
end
