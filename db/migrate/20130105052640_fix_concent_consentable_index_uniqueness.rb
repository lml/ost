class FixConcentConsentableIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :consents, [:consentable_id, :consentable_type], :unique => true, :name => "index_consents_on_consentable_id_scoped"
  end

  def down
    remove_index  :consents, :name => "index_consents_on_consentable_id_scoped"
  end
end
