class AddTerpConfirmationCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terp_confirmation_code, :string, unique: true
  end
end
