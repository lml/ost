# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateConsentForms < ActiveRecord::Migration
  def change
    create_table :consent_forms do |t|
      t.text :html
      t.boolean :esignature_required, :null => false
      t.string :name, :limit => 100

      t.timestamps
    end
  end
end
