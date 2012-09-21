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

ActiveRecord::Schema.define(:version => 20120920074701) do

  create_table "games", :force => true do |t|
    t.integer  "home_goals"
    t.integer  "guest_goals"
    t.integer  "home_id"
    t.integer  "guest_id"
    t.integer  "matchday_id"
    t.datetime "date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "games", ["home_id", "guest_id"], :name => "pair"

  create_table "matchdays", :force => true do |t|
    t.integer  "number"
    t.datetime "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "season_id"
  end

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "matchday_ids"
  end

  create_table "seasons_teams", :id => false, :force => true do |t|
    t.integer "season_id"
    t.integer "team_id"
  end

  create_table "seasons_users", :id => false, :force => true do |t|
    t.integer "season_id"
    t.integer "user_id"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
    t.boolean  "deactivated"
    t.string   "nickname"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
