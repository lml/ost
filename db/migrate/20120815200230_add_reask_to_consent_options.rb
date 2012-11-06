# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddReaskToConsentOptions < ActiveRecord::Migration
  def change
    add_column :consent_options, :days_before_reask, :float
    add_column :consent_options, :enable_reask, :boolean, :default => false
  end
end
