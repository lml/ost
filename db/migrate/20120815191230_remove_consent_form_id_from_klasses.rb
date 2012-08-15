class RemoveConsentFormIdFromKlasses < ActiveRecord::Migration
  def up
    remove_column :klasses, :consent_form_id
  end

  def down
    add_column :klasses, :consent_form_id, :integer
  end
end
