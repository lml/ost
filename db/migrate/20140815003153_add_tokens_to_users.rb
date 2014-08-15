class AddTokensToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terp_email_veritoken_id, :integer
    add_column :users, :terp_password_veritoken_id, :integer

    add_index :users, [:terp_email_veritoken_id], unique: true
    add_index :users, [:terp_password_veritoken_id], unique: true

    remove_column :users, :terp_confirmation_code
  end
end
