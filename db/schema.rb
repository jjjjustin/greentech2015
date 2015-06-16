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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141113065851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.string   "value"
    t.integer  "field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["field_id"], name: "index_answers_on_field_id", using: :btree

  create_table "fields", force: true do |t|
    t.text     "question"
    t.integer  "position"
    t.string   "question_type"
    t.integer  "step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fields", ["step_id"], name: "index_fields_on_step_id", using: :btree

  create_table "ideas", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ideas", ["user_id"], name: "index_ideas_on_user_id", using: :btree

  create_table "lessons", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lessons", ["template_id"], name: "index_lessons_on_template_id", using: :btree

  create_table "plan_options", force: true do |t|
    t.string   "stripe_plan_id"
    t.string   "title"
    t.integer  "idea_max"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", force: true do |t|
    t.string   "stripe_customer_token"
    t.string   "stripe_subscription_id"
    t.string   "plan_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["user_id"], name: "index_plans_on_user_id", using: :btree

  create_table "responses", force: true do |t|
    t.text     "value"
    t.boolean  "active",     default: true
    t.integer  "field_id"
    t.integer  "step_id"
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["field_id"], name: "index_responses_on_field_id", using: :btree
  add_index "responses", ["idea_id"], name: "index_responses_on_idea_id", using: :btree
  add_index "responses", ["step_id"], name: "index_responses_on_step_id", using: :btree

  create_table "steps", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.integer  "lesson_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "steps", ["lesson_id"], name: "index_steps_on_lesson_id", using: :btree

  create_table "templates", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "templates", ["user_id"], name: "index_templates_on_user_id", using: :btree

  create_table "user_profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "profession"
    t.string   "linkedin"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.boolean  "admin",                  default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
