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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_05_091502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "gender", default: 0
    t.date "birthdate"
    t.string "address"
    t.string "social_id"
    t.string "personal_email"
    t.string "business_email"
    t.string "mobile_numbers"
    t.string "landline_numbers"
    t.string "qualification"
    t.integer "graduation_year"
    t.date "date_of_employment"
    t.string "job_description"
    t.integer "work_type", default: 0
    t.date "date_of_social_insurance_joining"
    t.string "social_insurance_number"
    t.integer "military_status", default: 0
    t.integer "marital_status", default: 0
    t.string "nationality"
    t.integer "vacation_balance"
    t.string "avatar"
    t.string "middle_name"
    t.float "last_update", default: 0.0
    t.string "display_name"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "attendances", force: :cascade do |t|
    t.bigint "employee_id"
    t.datetime "checkin"
    t.datetime "checkout"
    t.float "time_spent", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_id"
    t.bigint "hr_id"
    t.index ["admin_id"], name: "index_attendances_on_admin_id"
    t.index ["employee_id"], name: "index_attendances_on_employee_id"
    t.index ["hr_id"], name: "index_attendances_on_hr_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "timeline_id"
    t.bigint "admin_id"
    t.bigint "hr_id"
    t.bigint "employee_id"
    t.text "content"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_comments_on_admin_id"
    t.index ["employee_id"], name: "index_comments_on_employee_id"
    t.index ["hr_id"], name: "index_comments_on_hr_id"
    t.index ["timeline_id"], name: "index_comments_on_timeline_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_documents_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "gender", default: 0
    t.date "birthdate"
    t.string "address"
    t.string "social_id"
    t.string "personal_email"
    t.string "business_email"
    t.string "mobile_numbers"
    t.string "landline_numbers"
    t.string "qualification"
    t.integer "graduation_year"
    t.date "date_of_employment"
    t.string "job_description"
    t.integer "work_type", default: 0
    t.date "date_of_social_insurance_joining"
    t.string "social_insurance_number"
    t.integer "military_status", default: 0
    t.integer "marital_status", default: 0
    t.string "nationality"
    t.integer "vacation_balance"
    t.string "avatar"
    t.bigint "section_id"
    t.integer "level", default: 0
    t.integer "supervisor_id"
    t.integer "salary", default: 0
    t.string "bank_account"
    t.string "access_token"
    t.integer "access_token_status", default: 0
    t.string "middle_name"
    t.string "photo"
    t.float "last_update", default: 0.0
    t.string "display_name"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["level"], name: "index_employees_on_level"
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
    t.index ["section_id"], name: "index_employees_on_section_id"
    t.index ["supervisor_id"], name: "index_employees_on_supervisor_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.integer "month"
    t.integer "year"
    t.integer "duration"
    t.date "starts_on"
    t.date "ends_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hr_roles", force: :cascade do |t|
    t.bigint "hr_id"
    t.bigint "role_id"
    t.index ["hr_id"], name: "index_hr_roles_on_hr_id"
    t.index ["role_id"], name: "index_hr_roles_on_role_id"
  end

  create_table "hrs", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "gender", default: 0
    t.date "birthdate"
    t.string "address"
    t.string "social_id"
    t.string "personal_email"
    t.string "business_email"
    t.string "mobile_numbers"
    t.string "landline_numbers"
    t.string "qualification"
    t.integer "graduation_year"
    t.date "date_of_employment"
    t.string "job_description"
    t.integer "work_type", default: 0
    t.date "date_of_social_insurance_joining"
    t.string "social_insurance_number"
    t.integer "military_status", default: 0
    t.integer "marital_status", default: 0
    t.string "nationality"
    t.integer "vacation_balance"
    t.string "avatar"
    t.string "middle_name"
    t.float "last_update", default: 0.0
    t.string "display_name"
    t.index ["email"], name: "index_hrs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_hrs_on_reset_password_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.string "sender_type"
    t.bigint "sender_id"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.string "subject"
    t.text "content"
    t.integer "read_status", default: 0
    t.integer "starring", default: 0
    t.integer "trashing", default: 0
    t.string "files", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_status"], name: "index_messages_on_read_status"
    t.index ["recipient_type", "recipient_id"], name: "index_messages_on_recipient_type_and_recipient_id"
    t.index ["sender_type", "sender_id"], name: "index_messages_on_sender_type_and_sender_id"
    t.index ["starring"], name: "index_messages_on_starring"
    t.index ["trashing"], name: "index_messages_on_trashing"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.integer "read_status", default: 0
    t.index ["read_status"], name: "index_notifications_on_read_status"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "target_model_name"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reacts", force: :cascade do |t|
    t.bigint "timeline_id"
    t.string "reactor_type"
    t.bigint "reactor_id"
    t.integer "react", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["react"], name: "index_reacts_on_react"
    t.index ["reactor_type", "reactor_id"], name: "index_reacts_on_reactor_type_and_reactor_id"
    t.index ["timeline_id"], name: "index_reacts_on_timeline_id"
  end

  create_table "recruitments", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "mobile_number"
    t.string "landline_number"
    t.string "position"
    t.text "feedback"
    t.integer "decision", default: 0
    t.string "cv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "permission_id"
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_messages", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "room_id"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_room_messages_on_employee_id"
    t.index ["room_id"], name: "index_room_messages_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_sections_on_parent_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "ip_addresses", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "work_from_home", default: 0
  end

  create_table "timelines", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "hr_id"
    t.bigint "employee_id"
    t.text "content"
    t.string "images", default: [], array: true
    t.integer "kind", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creation", default: 0
    t.index ["admin_id"], name: "index_timelines_on_admin_id"
    t.index ["employee_id"], name: "index_timelines_on_employee_id"
    t.index ["hr_id"], name: "index_timelines_on_hr_id"
  end

  create_table "updates", force: :cascade do |t|
    t.float "version"
    t.text "changelog"
    t.string "images", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vacation_requests", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "hr_id"
    t.integer "supervisor_id"
    t.date "starts_on"
    t.date "ends_on"
    t.text "reason"
    t.text "supervisor_feedback"
    t.text "hr_feedback"
    t.integer "status", default: 0
    t.text "escalation_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0
    t.time "starts_at"
    t.time "ends_at"
    t.index ["employee_id"], name: "index_vacation_requests_on_employee_id"
    t.index ["hr_id"], name: "index_vacation_requests_on_hr_id"
    t.index ["kind"], name: "index_vacation_requests_on_kind"
    t.index ["supervisor_id"], name: "index_vacation_requests_on_supervisor_id"
  end

  add_foreign_key "attendances", "admins"
  add_foreign_key "attendances", "employees"
  add_foreign_key "attendances", "hrs"
  add_foreign_key "comments", "admins"
  add_foreign_key "comments", "employees"
  add_foreign_key "comments", "hrs"
  add_foreign_key "comments", "timelines"
  add_foreign_key "documents", "employees"
  add_foreign_key "employees", "sections"
  add_foreign_key "hr_roles", "hrs"
  add_foreign_key "hr_roles", "roles"
  add_foreign_key "reacts", "timelines"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "room_messages", "employees"
  add_foreign_key "room_messages", "rooms"
  add_foreign_key "timelines", "admins"
  add_foreign_key "timelines", "employees"
  add_foreign_key "timelines", "hrs"
  add_foreign_key "vacation_requests", "employees"
  add_foreign_key "vacation_requests", "hrs"
end
