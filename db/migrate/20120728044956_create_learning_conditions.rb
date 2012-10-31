# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateLearningConditions < ActiveRecord::Migration
  def change
    create_table :learning_conditions do |t|
      t.integer :cohort_id

      t.timestamps
    end
  end
end
