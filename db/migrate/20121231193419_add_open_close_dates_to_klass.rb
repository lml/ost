class AddOpenCloseDatesToKlass < ActiveRecord::Migration
  def change
    add_column :klasses, :open_date, :datetime
    add_column :klasses, :close_date, :datetime
  end
end
