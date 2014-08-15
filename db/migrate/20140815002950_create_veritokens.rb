class CreateVeritokens < ActiveRecord::Migration
  def change
    create_table :veritokens do |t|
      t.string :token
      t.integer :num_attempts_left
      t.integer :num_days_active

      t.timestamps
    end

    add_index :veritokens, [:token], unique: true
  end
end
