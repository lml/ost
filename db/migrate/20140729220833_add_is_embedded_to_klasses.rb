class AddIsEmbeddedToKlasses < ActiveRecord::Migration
  def change
    add_column :klasses, :is_embedded, :boolean, default: false, null: false
  end
end
