# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddHasDroppedToStudent < ActiveRecord::Migration
  def change
    add_column :students, :has_dropped, :boolean, :null => false, :default => false
  end
end
