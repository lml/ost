class FixAanIndexCohort < ActiveRecord::Migration
  def up
    add_index     :cohorts, [:number, :klass_id], :unique => true, :name => "index_cohorts_on_number_scoped"
  end

  def down
    remove_index  :cohorts, :name => "index_cohorts_on_number_scoped"
  end
end
