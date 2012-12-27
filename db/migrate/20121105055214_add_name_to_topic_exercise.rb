# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddNameToTopicExercise < ActiveRecord::Migration
  def change
    add_column :topic_exercises, :name, :string
  end
end
