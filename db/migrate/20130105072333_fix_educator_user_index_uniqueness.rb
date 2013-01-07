class FixEducatorUserIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :educators, [:user_id, :klass_id], :unique => true, :name => "index_educators_on_user_id_scoped"
  end

  def down
    remove_index  :educators, :name => "index_educators_on_user_id_scoped"
  end
end
