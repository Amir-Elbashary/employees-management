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

ActiveRecord::Schema.define(version: 2019_08_21_111125) do

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
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
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
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["level"], name: "index_employees_on_level"
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
    t.index ["section_id"], name: "index_employees_on_section_id"
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
    t.index ["email"], name: "index_hrs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_hrs_on_reset_password_token", unique: true
  end

  create_table "permissions", force: :cascade do |t|
    t.string "target_model_name"
    t.string "action"
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

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_sections_on_parent_id"
  end

  add_foreign_key "employees", "sections"
  add_foreign_key "hr_roles", "hrs"
  add_foreign_key "hr_roles", "roles"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
end
