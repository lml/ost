# This migration comes from unconfirm_engine (originally 20140613110759)
class CreateUnconfirmUserSettings < ActiveRecord::Migration
  def change
    create_table(:unconfirm_user_settings) do |t|
      t.integer :user_id, :null => false
      t.text    :settings
      t.timestamps
    end

    add_index :unconfirm_user_settings, :user_id
  end
end
