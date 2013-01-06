class FixOrganizationManagerUserIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :organization_managers, [:user_id, :organization_id], :unique => true, :name => "index_organization_managers_on_user_id_scoped"
  end

  def down
    remove_index  :organization_managers, :name => "index_organization_managers_on_user_id_scoped"
  end
end
