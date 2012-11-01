# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :url
      t.boolean :is_dynamic
      t.text :content_cache

      t.timestamps
    end
  end
end
