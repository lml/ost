class CreateExternalAssignments < ActiveRecord::Migration
  def change
    create_table :external_assignments do |t|
      t.integer     :klass_id,  null: false
      t.integer     :number
      t.string      :name,      limit: 100
      t.timestamps
    end

    create_table :external_assignment_exercises do |t|
      t.integer     :external_assignment_id,  null: false
      t.integer     :concept_id
      t.integer     :number
      t.string      :name,                    limit: 100
      t.timestamps
    end

    create_table :student_external_assignments do |t|
      t.integer     :external_assignment_id,  null:     false
      t.integer     :student_id,              null:     false
      t.float       :grade,                   default:  0.0
      t.timestamps
    end

    create_table  :student_external_assignment_exercises do |t|
      t.integer     :external_assignment_exercise_id, null:     false
      t.integer     :student_external_assignment_id,  null:     false
      t.float       :grade,                           default:  0.0
      t.timestamps
    end
  end
end
