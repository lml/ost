# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130106053146) do

  create_table "assignment_coworkers", :force => true do |t|
    t.integer  "student_assignment_id"
    t.integer  "student_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "assignment_coworkers", ["student_assignment_id"], :name => "index_assignment_coworkers_on_student_assignment_id"
  add_index "assignment_coworkers", ["student_id", "student_assignment_id"], :name => "index_assignment_coworkers_on_student_id_scoped", :unique => true

  create_table "assignment_exercises", :force => true do |t|
    t.integer  "assignment_id",     :null => false
    t.integer  "topic_exercise_id", :null => false
    t.integer  "number"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "assignment_exercises", ["assignment_id"], :name => "index_assignment_exercises_on_assignment_id"
  add_index "assignment_exercises", ["number", "assignment_id"], :name => "index_assignment_exercises_on_number_scoped", :unique => true
  add_index "assignment_exercises", ["topic_exercise_id", "assignment_id"], :name => "index_assignment_exercises_on_topic_exercise_id_scoped", :unique => true
  add_index "assignment_exercises", ["topic_exercise_id"], :name => "index_assignment_exercises_on_topic_exercise_id"

  create_table "assignment_plan_topics", :force => true do |t|
    t.integer  "assignment_plan_id",                      :null => false
    t.integer  "topic_id",                                :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "num_exercises_to_use"
    t.boolean  "hide_resources",       :default => false
  end

  add_index "assignment_plan_topics", ["assignment_plan_id"], :name => "index_assignment_plan_topics_on_assignment_plan_id"
  add_index "assignment_plan_topics", ["topic_id"], :name => "index_assignment_plan_topics_on_topic_id"

  create_table "assignment_plans", :force => true do |t|
    t.integer  "learning_plan_id",                     :null => false
    t.string   "name",                  :limit => 100
    t.boolean  "is_test"
    t.boolean  "is_open_book"
    t.boolean  "is_group_work_allowed"
    t.boolean  "is_ready"
    t.text     "introduction"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.float    "grade_weight"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "max_num_exercises"
    t.string   "exercise_tags"
    t.integer  "section_id"
  end

  add_index "assignment_plans", ["learning_plan_id"], :name => "index_assignments_on_learning_plan_id"
  add_index "assignment_plans", ["name", "learning_plan_id"], :name => "index_assignment_plan_on_name_scoped", :unique => true
  add_index "assignment_plans", ["section_id"], :name => "index_assignment_plans_on_section_id"

  create_table "assignments", :force => true do |t|
    t.integer  "assignment_plan_id"
    t.integer  "cohort_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "assignments", ["assignment_plan_id"], :name => "index_assignments_on_assignment_plan_id"
  add_index "assignments", ["cohort_id", "assignment_plan_id"], :name => "index_assignments_on_cohort_id_scoped", :unique => true
  add_index "assignments", ["cohort_id"], :name => "index_assignments_on_cohort_id"

  create_table "cohorts", :force => true do |t|
    t.integer  "section_id"
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "klass_id",   :null => false
    t.string   "name"
  end

  add_index "cohorts", ["klass_id"], :name => "index_cohorts_on_klass_id"
  add_index "cohorts", ["number", "klass_id"], :name => "index_cohorts_on_number_scoped", :unique => true
  add_index "cohorts", ["section_id"], :name => "index_cohorts_on_section_id"

  create_table "concepts", :force => true do |t|
    t.string   "name"
    t.integer  "learning_plan_id", :null => false
    t.integer  "number"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "concepts", ["learning_plan_id"], :name => "index_concepts_on_learning_plan_id"
  add_index "concepts", ["name", "learning_plan_id"], :name => "index_concepts_on_name_scoped", :unique => true
  add_index "concepts", ["number", "learning_plan_id"], :name => "index_concepts_on_number_scoped", :unique => true

  create_table "consent_forms", :force => true do |t|
    t.text     "html"
    t.boolean  "esignature_required",                :null => false
    t.string   "name",                :limit => 100
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "consent_options", :force => true do |t|
    t.integer  "consent_optionable_id",                                    :null => false
    t.string   "consent_optionable_type", :limit => 40,                    :null => false
    t.integer  "consent_form_id"
    t.datetime "opens_at"
    t.datetime "closes_at"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.float    "days_before_reask"
    t.boolean  "enable_reask",                          :default => false
  end

  add_index "consent_options", ["consent_optionable_id", "consent_optionable_type"], :name => "consent_optionable_index"

  create_table "consents", :force => true do |t|
    t.integer  "consentable_id"
    t.string   "consentable_type"
    t.string   "esignature"
    t.boolean  "did_consent"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "consent_options_id", :null => false
  end

  add_index "consents", ["consent_options_id"], :name => "index_consents_on_consent_options_id"
  add_index "consents", ["consentable_id", "consentable_type"], :name => "index_consents_on_consentable_id_scoped", :unique => true

  create_table "course_instructors", :force => true do |t|
    t.integer  "course_id",  :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "course_instructors", ["course_id"], :name => "index_course_instructors_on_course_id"
  add_index "course_instructors", ["user_id", "course_id"], :name => "index_course_instructor_on_user_id_scoped", :unique => true
  add_index "course_instructors", ["user_id"], :name => "index_course_instructors_on_user_id"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "typically_offered"
    t.integer  "organization_id",   :null => false
    t.integer  "number"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "short_name"
  end

  add_index "courses", ["name", "organization_id"], :name => "index_courses_on_name_scoped", :unique => true
  add_index "courses", ["organization_id"], :name => "index_courses_on_organization_id"

  create_table "educators", :force => true do |t|
    t.integer  "klass_id",              :null => false
    t.integer  "user_id",               :null => false
    t.boolean  "is_instructor"
    t.boolean  "is_teaching_assistant"
    t.boolean  "is_grader"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "educators", ["klass_id"], :name => "index_educators_on_klass_id"
  add_index "educators", ["user_id", "klass_id"], :name => "index_educators_on_user_id_scoped", :unique => true
  add_index "educators", ["user_id"], :name => "index_educators_on_user_id"

  create_table "exercises", :force => true do |t|
    t.string   "url"
    t.boolean  "is_dynamic"
    t.text     "content_cache"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "exercises", ["url"], :name => "index_exercises_on_url", :unique => true

  create_table "feedback_conditions", :force => true do |t|
    t.integer  "learning_condition_id", :null => false
    t.text     "settings"
    t.string   "type"
    t.integer  "number"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "feedback_conditions", ["learning_condition_id"], :name => "index_feedback_conditions_on_learning_condition_id"

  create_table "klasses", :force => true do |t|
    t.integer  "course_id"
    t.text     "approved_emails"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "time_zone"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "is_controlled_experiment",   :default => false, :null => false
    t.boolean  "allow_student_specified_id", :default => false, :null => false
    t.datetime "open_date"
    t.datetime "close_date"
  end

  add_index "klasses", ["course_id"], :name => "index_klasses_on_course_id"

  create_table "learning_conditions", :force => true do |t|
    t.integer  "cohort_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "learning_conditions", ["cohort_id"], :name => "index_learning_conditions_on_cohort_id"

  create_table "learning_plans", :force => true do |t|
    t.integer  "klass_id",                              :null => false
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "test_exercise_tags",    :default => ""
    t.string   "nontest_exercise_tags", :default => ""
  end

  add_index "learning_plans", ["klass_id"], :name => "index_learning_plans_on_klass_id"

  create_table "organization_managers", :force => true do |t|
    t.integer  "organization_id", :null => false
    t.integer  "user_id",         :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "organization_managers", ["organization_id"], :name => "index_organization_managers_on_organization_id"
  add_index "organization_managers", ["user_id", "organization_id"], :name => "index_organization_managers_on_user_id_scoped", :unique => true
  add_index "organization_managers", ["user_id"], :name => "index_organization_managers_on_user_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "default_time_zone"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "organizations", ["name"], :name => "index_organizations_on_name", :unique => true

  create_table "presentation_conditions", :force => true do |t|
    t.integer  "learning_condition_id", :null => false
    t.text     "settings"
    t.integer  "number"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "presentation_conditions", ["learning_condition_id"], :name => "index_presentation_conditions_on_learning_condition_id"

  create_table "registration_requests", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.integer  "section_id",                         :null => false
    t.boolean  "is_auditing",                        :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "student_specified_id", :limit => 30
  end

  add_index "registration_requests", ["section_id", "user_id"], :name => "index_registration_requests_on_section_id_scoped", :unique => true
  add_index "registration_requests", ["section_id"], :name => "index_registration_requests_on_section_id"
  add_index "registration_requests", ["user_id"], :name => "index_registration_requests_on_user_id"

  create_table "researchers", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "researchers", ["user_id"], :name => "index_researchers_on_user_id", :unique => true

  create_table "resources", :force => true do |t|
    t.integer  "topic_id",   :null => false
    t.string   "url"
    t.string   "name"
    t.text     "notes"
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "resources", ["topic_id"], :name => "index_resources_on_topic_id"
  add_index "resources", ["url", "topic_id"], :name => "index_resources_on_url_scoped", :unique => true

  create_table "response_times", :force => true do |t|
    t.integer  "response_timeable_id",                 :null => false
    t.string   "response_timeable_type", :limit => 40, :null => false
    t.string   "event"
    t.string   "note"
    t.string   "page"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "response_times", ["response_timeable_id", "response_timeable_type"], :name => "response_timeable_index"

  create_table "scheduled_notifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "message"
    t.datetime "send_after"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "scheduled_notifications", ["user_id"], :name => "index_scheduled_notifications_on_user_id"

  create_table "schedulers", :force => true do |t|
    t.text     "settings"
    t.integer  "learning_condition_id", :null => false
    t.string   "type"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "schedulers", ["learning_condition_id"], :name => "index_schedulers_on_learning_condition_id"

  create_table "sections", :force => true do |t|
    t.integer  "klass_id",   :null => false
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sections", ["klass_id"], :name => "index_sections_on_klass_id"
  add_index "sections", ["name", "klass_id"], :name => "index_sections_on_name_scoped", :unique => true

  create_table "site_licenses", :force => true do |t|
    t.text     "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "student_assignments", :force => true do |t|
    t.integer  "student_id",      :null => false
    t.integer  "assignment_id",   :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "completed_at"
    t.datetime "observed_due_at"
  end

  add_index "student_assignments", ["assignment_id"], :name => "index_student_assignments_on_assignment_id"
  add_index "student_assignments", ["student_id", "assignment_id"], :name => "index_student_assignments_on_student_id_scoped", :unique => true
  add_index "student_assignments", ["student_id"], :name => "index_student_assignments_on_student_id"

  create_table "student_exercises", :force => true do |t|
    t.integer  "student_assignment_id",                         :null => false
    t.integer  "assignment_exercise_id",                        :null => false
    t.text     "content_cache"
    t.text     "free_response"
    t.datetime "free_response_submitted_at"
    t.integer  "free_response_confidence"
    t.integer  "selected_answer"
    t.datetime "selected_answer_submitted_at"
    t.boolean  "was_submitted_late"
    t.float    "automated_credit"
    t.float    "manual_credit"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.float    "feedback_credit_multiplier",   :default => 1.0
  end

  add_index "student_exercises", ["assignment_exercise_id", "student_assignment_id"], :name => "index_student_exercises_on_assignment_exercise_scoped", :unique => true
  add_index "student_exercises", ["assignment_exercise_id"], :name => "index_student_exercises_on_assignment_exercise_id"
  add_index "student_exercises", ["student_assignment_id"], :name => "index_student_exercises_on_student_assignment_id"

  create_table "students", :force => true do |t|
    t.integer  "cohort_id"
    t.integer  "section_id",                                            :null => false
    t.integer  "user_id",                                               :null => false
    t.boolean  "is_auditing"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "student_specified_id", :limit => 30
    t.boolean  "has_dropped",                        :default => false, :null => false
  end

  add_index "students", ["cohort_id"], :name => "index_students_on_cohort_id"
  add_index "students", ["section_id"], :name => "index_students_on_section_id"
  add_index "students", ["user_id", "cohort_id"], :name => "index_students_on_user_id_scoped", :unique => true
  add_index "students", ["user_id"], :name => "index_students_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topic_exercises", :force => true do |t|
    t.integer  "topic_id",                              :null => false
    t.integer  "exercise_id",                           :null => false
    t.integer  "concept_id"
    t.integer  "number"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "reserved_for_tests", :default => false
    t.string   "name"
  end

  add_index "topic_exercises", ["concept_id"], :name => "index_topic_exercises_on_concept_id"
  add_index "topic_exercises", ["exercise_id"], :name => "index_topic_exercises_on_exercise_id"
  add_index "topic_exercises", ["topic_id"], :name => "index_topic_exercises_on_topic_id"

  create_table "topics", :force => true do |t|
    t.string   "name",             :limit => 100
    t.integer  "learning_plan_id",                :null => false
    t.integer  "number"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "topics", ["learning_plan_id"], :name => "index_topics_on_learning_plan_id"
  add_index "topics", ["name", "learning_plan_id"], :name => "index_topics_on_name_scoped", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                                                          :null => false
    t.string   "encrypted_password",                   :default => "",                           :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "username",                                                                       :null => false
    t.datetime "disabled_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_administrator",                     :default => false,                        :null => false
    t.string   "research_id",                                                                    :null => false
    t.string   "education_id",                                                                   :null => false
    t.string   "nickname"
    t.datetime "created_at",                                                                     :null => false
    t.datetime "updated_at",                                                                     :null => false
    t.string   "time_zone",              :limit => 40, :default => "Central Time (US & Canada)", :null => false
    t.boolean  "receives_error_notices"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["education_id"], :name => "index_users_on_education_id", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["research_id"], :name => "index_users_on_research_id", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "website_configurations", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.string   "value_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
