class FixOrganizationNameUniqueness < ActiveRecord::Migration
  def up
    add_index     :organizations, :name, :unique => true, :name => "index_organizations_on_name"
  end

  def down
    remove_index  :organizations, :name => "index_organizations_on_name"
  end
end
