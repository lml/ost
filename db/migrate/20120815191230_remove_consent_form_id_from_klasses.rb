# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class RemoveConsentFormIdFromKlasses < ActiveRecord::Migration
  def up
    remove_column :klasses, :consent_form_id
  end

  def down
    add_column :klasses, :consent_form_id, :integer
  end
end
