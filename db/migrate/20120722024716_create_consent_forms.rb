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
