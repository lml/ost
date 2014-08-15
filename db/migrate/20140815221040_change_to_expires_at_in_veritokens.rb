class ChangeToExpiresAtInVeritokens < ActiveRecord::Migration
  def up
    remove_column :veritokens, :num_days_active
    add_column :veritokens, :expires_at, :datetime
  end

  def down
    remove_column :veritokens, :expires_at
    add_column :veritokens, :num_days_active, :integer
  end
end
