class AddKlassIdToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :klass_id, :integer
    add_index :cohorts, :klass_id
    
    Cohort.all.each do |cohort|
      cohort.klass = cohort.section.klass
      cohort.save!
    end
    
    change_column :cohorts, :klass_id, :integer, :null => false
    
    change_column :cohorts, :section_id, :integer, :null => true
  end
end
