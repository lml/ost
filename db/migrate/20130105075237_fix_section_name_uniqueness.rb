class FixSectionNameUniqueness < ActiveRecord::Migration
  def up
    add_index     :sections, [:name, :klass_id], :unique => true, :name => "index_sections_on_name_scoped"
  end

  def down
    remove_index  :sections, :name => "index_sections_on_name_scoped"
  end
end
