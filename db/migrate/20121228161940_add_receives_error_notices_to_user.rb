class AddReceivesErrorNoticesToUser < ActiveRecord::Migration
  def change
    add_column :users, :receives_error_notices, :boolean
  end
end
