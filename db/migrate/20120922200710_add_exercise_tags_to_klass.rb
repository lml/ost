# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddExerciseTagsToKlass < ActiveRecord::Migration
  def change
    add_column :klasses, :test_exercise_tags, :string
    add_column :klasses, :nontest_exercise_tags, :string
  end
end
