class DropPercentSchedulers < ActiveRecord::Migration
  def up
    drop_table :percent_schedulers
    change_column :schedulers, :learning_condition_id, :integer, :null => false
    add_index :schedulers, :learning_condition_id
  end

  def down
    raise IllegalOperation
  end
end
