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

ActiveRecord::Schema.define(version: 20141112063951) do

  create_table "action_whos", force: true do |t|
    t.integer  "action_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actions", force: true do |t|
    t.integer  "who"
    t.datetime "act_time"
    t.string   "where"
    t.string   "what"
    t.integer  "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "action_type"
  end

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "exp"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approves", force: true do |t|
    t.integer  "approve_user_id"
    t.integer  "approved_user_id"
    t.integer  "approve_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "action_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "greats", force: true do |t|
    t.integer  "action_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password"
    t.string   "detail"
    t.boolean  "game_flag"
  end

  create_table "levels", force: true do |t|
    t.integer  "level"
    t.integer  "required_exp"
    t.string   "degree"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "level"
    t.boolean  "read_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pageviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "request_page"
    t.integer  "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid",                    default: "", null: false
    t.string   "provider",               default: "", null: false
    t.string   "name"
    t.string   "image"
    t.integer  "group_id"
    t.integer  "exp"
    t.integer  "level"
    t.integer  "mail_count"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

end
