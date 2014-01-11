class AddEnableAssignmentByCohortToKlass < ActiveRecord::Migration
  def change
    add_column :klasses, :enable_assignment_by_cohort, :boolean, default: false
  end
end
