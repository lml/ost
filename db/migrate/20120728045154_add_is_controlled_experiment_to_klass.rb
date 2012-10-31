# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddIsControlledExperimentToKlass < ActiveRecord::Migration
  def change
    add_column :klasses, :is_controlled_experiment, :boolean, :null => false, :default => false
  end
end
