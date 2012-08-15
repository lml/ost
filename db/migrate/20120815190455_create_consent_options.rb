class CreateConsentOptions < ActiveRecord::Migration
  def change
    create_table :consent_options do |t|
      t.integer :consent_optionable_id, :null => false
      t.string :consent_optionable_type, :null => false, :limit => 40
      t.integer :consent_form_id
      t.datetime :opens_at
      t.datetime :closes_at

      t.timestamps
    end
    
    add_index :consent_options, [:consent_optionable_id, :consent_optionable_type], :name => 'consent_optionable_index'
  end
end
