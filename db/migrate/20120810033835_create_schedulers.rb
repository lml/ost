class CreateSchedulers < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.text :settings
      t.integer :learning_condition_id
      t.string :type

      t.timestamps
    end
  end
end
