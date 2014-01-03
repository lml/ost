class CreateExternalAssignments < ActiveRecord::Migration
  def change
    create_table :external_assignments do |t|
      t.integer     :klass_id,  null: false
      t.integer     :number
      t.string      :name,      limit: 100
      t.timestamps
    end

    add_index :external_assignments, :klass_id

    create_table :external_assignment_exercises do |t|
      t.integer     :external_assignment_id,  null: false
      t.integer     :concept_id
      t.integer     :topic_id
      t.integer     :number
      t.string      :name,                    limit: 100
      t.timestamps
    end

    add_index :external_assignment_exercises, :external_assignment_id, name: 'index_eae_on_external_assignment_id'
    add_index :external_assignment_exercises, :concept_id, name: 'index_eae_on_concept_id'
    add_index :external_assignment_exercises, :topic_id, name: 'index_eae_on_topic_id'

    create_table :student_external_assignments do |t|
      t.integer     :external_assignment_id,  null:     false
      t.integer     :student_id,              null:     false
      t.float       :grade,                   default:  0.0
      t.timestamps
    end

    add_index :student_external_assignments, :external_assignment_id, name: 'index_sea_on_external_assignment_id'
    add_index :student_external_assignments, :student_id, name: 'index_sea_on_student_id'

    create_table  :student_external_assignment_exercises do |t|
      t.integer     :external_assignment_exercise_id, null:     false
      t.integer     :student_external_assignment_id,  null:     false
      t.float       :grade,                           default:  0.0
      t.timestamps
    end

    add_index :student_external_assignment_exercises, :external_assignment_exercise_id, name: 'index_seae_on_eae_id'
    add_index :student_external_assignment_exercises, :student_external_assignment_id, name: 'index_seae_on_sea_id'
  end
end
