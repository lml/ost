# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddIndexesToUsers < ActiveRecord::Migration
  def change
    add_index :users, :research_id, :unique => true
    add_index :users, :education_id, :unique => true
  end
end
