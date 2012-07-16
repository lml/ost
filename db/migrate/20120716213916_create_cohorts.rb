class CreateCohorts < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
      t.integer :section_id
      t.integer :number

      t.timestamps
    end
  end
end
