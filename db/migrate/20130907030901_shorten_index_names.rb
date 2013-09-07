class ShortenIndexNames < ActiveRecord::Migration
  def change
    rename_index :taggings,                "index_taggings_on_taggable_id_and_taggable_type_and_context", "index_taggings_on_taggable_id_type_context"
    rename_index :presentation_conditions, "index_presentation_conditions_on_learning_condition_id",      "index_pcs_on_lc_id"
    rename_index :presentation_conditions, "index_presentation_condition_on_number_scoped",               "index_pcs_on_number_scoped"
    rename_index :assignment_coworkers,    "index_assignment_coworkers_on_student_assignment_id",         "index_assignment_cws_on_sa_id"
    rename_index :feedback_conditions,     "index_feedback_conditions_on_learning_condition_id",          "index_fcs_on_lc_id"
    rename_index :assignment_plan_topics,  "index_assignment_plan_topics_on_assignment_plan_id",          "index_apts_on_ap_id"
    rename_index :assignment_exercises,    "index_assignment_exercises_on_topic_exercise_id_scoped",      "index_aes_on_te_id_scoped"
  end
end
