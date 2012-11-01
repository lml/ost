# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateWebsiteConfigurations < ActiveRecord::Migration
  def change
    create_table(:website_configurations) do |t|
      t.string :name
      t.string :value
      t.string :value_type

      t.timestamps
    end
  end
end
