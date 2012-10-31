# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateSiteLicenses < ActiveRecord::Migration
  def change
    create_table :site_licenses do |t|
      t.text :title
      t.text :body
      
      t.timestamps
    end
  end
end
