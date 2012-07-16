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

ActiveRecord::Schema.define(:version => 20120716215801) do

  create_table "cohorts", :force => true do |t|
    t.integer  "section_id"
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cohorts", ["section_id"], :name => "index_cohorts_on_section_id"

  create_table "course_instructors", :force => true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "course_instructors", ["course_id"], :name => "index_course_instructors_on_course_id"
  add_index "course_instructors", ["user_id"], :name => "index_course_instructors_on_user_id"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "typically_offered"
    t.integer  "organization_id"
    t.integer  "number"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "courses", ["organization_id"], :name => "index_courses_on_organization_id"

  create_table "educators", :force => true do |t|
    t.integer  "offered_course_id"
    t.integer  "user_id"
    t.boolean  "is_instructor"
    t.boolean  "is_teaching_assistant"
    t.boolean  "is_grader"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "educators", ["offered_course_id"], :name => "index_educators_on_offered_course_id"
  add_index "educators", ["user_id"], :name => "index_educators_on_user_id"

  create_table "offered_courses", :force => true do |t|
    t.integer  "course_id"
    t.text     "approved_emails"
    t.integer  "consent_form_id"
    t.datetime "start_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "offered_courses", ["consent_form_id"], :name => "index_offered_courses_on_consent_form_id"
  add_index "offered_courses", ["course_id"], :name => "index_offered_courses_on_course_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "default_time_zone"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "registration_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "section_id"
    t.boolean  "is_auditing"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "registration_requests", ["section_id"], :name => "index_registration_requests_on_section_id"
  add_index "registration_requests", ["user_id"], :name => "index_registration_requests_on_user_id"

  create_table "researchers", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "researchers", ["user_id"], :name => "index_researchers_on_user_id"

  create_table "sections", :force => true do |t|
    t.integer  "offered_course_id"
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "sections", ["offered_course_id"], :name => "index_sections_on_offered_course_id"

  create_table "students", :force => true do |t|
    t.integer  "cohort_id"
    t.integer  "user_id"
    t.boolean  "is_auditing"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "students", ["cohort_id"], :name => "index_students_on_cohort_id"
  add_index "students", ["user_id"], :name => "index_students_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "username"
    t.datetime "disabled_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_administrator",       :default => false
    t.string   "research_id"
    t.string   "education_id"
    t.string   "nickname"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
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
