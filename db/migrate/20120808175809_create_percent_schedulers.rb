class CreatePercentSchedulers < ActiveRecord::Migration
  def change
    create_table :percent_schedulers do |t|
      t.text :settings
      t.integer :learning_condition_id

      t.timestamps
    end
    
    add_index :percent_schedulers, :learning_condition_id
  end
end
