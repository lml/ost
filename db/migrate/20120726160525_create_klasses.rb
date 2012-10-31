# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateKlasses < ActiveRecord::Migration
  def change
    create_table :klasses do |t|
      t.integer :course_id
      t.text :approved_emails
      t.integer :consent_form_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :time_zone

      t.timestamps
    end
    
    add_index :klasses, :course_id
    add_index :klasses, :consent_form_id
  end
end
