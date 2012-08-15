class SwitchWhatConsentsBelongsTo < ActiveRecord::Migration
  def up
    remove_index :consents, :consent_form_id
    remove_column :consents, :consent_form_id
    # http://stackoverflow.com/a/6710280 for why add_column then change_column
    add_column :consents, :consent_options_id, :integer
    change_column :consents, :consent_options_id, :integer, :null => false
    add_index :consents, :consent_options_id
  end

  def down
    raise IllegalOperation
  end
end
