class AddHasDroppedToStudent < ActiveRecord::Migration
  def change
    add_column :students, :has_dropped, :boolean, :null => false, :default => false
  end
end
