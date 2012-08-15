class AddReaskToConsentOptions < ActiveRecord::Migration
  def change
    add_column :consent_options, :days_before_reask, :float
    add_column :consent_options, :enable_reask, :boolean, :default => false
  end
end
