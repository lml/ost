class CreateConsents < ActiveRecord::Migration
  def change
    create_table :consents do |t|
      t.integer :consentable_id
      t.string :consentable_type
      t.string :esignature
      t.integer :consent_form_id
      t.boolean :did_consent

      t.timestamps
    end
    
    add_index :consents, :consent_form_id
    add_index :consents, [:consentable_id, :consentable_type], :name => 'consentable_index'
  end
end
