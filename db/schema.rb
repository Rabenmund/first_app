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

ActiveRecord::Schema.define(:version => 20121106160101) do

  create_table "games", :force => true do |t|
    t.integer  "home_goals"
    t.integer  "guest_goals"
    t.integer  "home_id"
    t.integer  "guest_id"
    t.integer  "matchday_id"
    t.datetime "date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "finished"
  end

  add_index "games", ["date"], :name => "index_games_on_date"
  add_index "games", ["finished"], :name => "index_games_on_finished"
  add_index "games", ["guest_id"], :name => "index_games_on_guest_id"
  add_index "games", ["home_id"], :name => "index_games_on_home_id"
  add_index "games", ["matchday_id"], :name => "index_games_on_matchday_id"

  create_table "matchday_user_results", :force => true do |t|
    t.integer  "matchday_id"
    t.integer  "user_id"
    t.integer  "points"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "matchdays", :force => true do |t|
    t.integer  "number"
    t.datetime "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "season_id"
    t.boolean  "finished"
  end

  add_index "matchdays", ["date"], :name => "index_matchdays_on_date"
  add_index "matchdays", ["finished"], :name => "index_matchdays_on_finished"
  add_index "matchdays", ["number"], :name => "index_matchdays_on_number"
  add_index "matchdays", ["season_id"], :name => "index_matchdays_on_season_id"

  create_table "matchdays_seconds", :id => false, :force => true do |t|
    t.integer "matchday_id"
    t.integer "user_id"
  end

  add_index "matchdays_seconds", ["matchday_id"], :name => "index_matchdays_seconds_on_matchday_id"
  add_index "matchdays_seconds", ["user_id"], :name => "index_matchdays_seconds_on_user_id"

  create_table "matchdays_winners", :id => false, :force => true do |t|
    t.integer "matchday_id"
    t.integer "user_id"
  end

  add_index "matchdays_winners", ["matchday_id"], :name => "index_matchdays_winners_on_matchday_id"
  add_index "matchdays_winners", ["user_id"], :name => "index_matchdays_winners_on_user_id"

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"
  add_index "microposts", ["user_id"], :name => "index_microposts_on_user_id"

  create_table "season_user_results", :force => true do |t|
    t.integer  "season_id"
    t.integer  "user_id"
    t.integer  "points"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "matchday_ids"
    t.boolean  "finished"
  end

  add_index "seasons", ["end_date"], :name => "index_seasons_on_end_date"
  add_index "seasons", ["finished"], :name => "index_seasons_on_finished"
  add_index "seasons", ["start_date"], :name => "index_seasons_on_start_date"

  create_table "seasons_teams", :id => false, :force => true do |t|
    t.integer "season_id"
    t.integer "team_id"
  end

  add_index "seasons_teams", ["season_id"], :name => "index_seasons_teams_on_season_id"
  add_index "seasons_teams", ["team_id"], :name => "index_seasons_teams_on_team_id"

  create_table "seasons_users", :id => false, :force => true do |t|
    t.integer "season_id"
    t.integer "user_id"
  end

  add_index "seasons_users", ["season_id"], :name => "index_seasons_users_on_season_id"
  add_index "seasons_users", ["user_id"], :name => "index_seasons_users_on_user_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "shortname"
    t.string   "chars"
  end

  add_index "teams", ["chars"], :name => "index_teams_on_chars"

  create_table "tipps", :force => true do |t|
    t.integer  "home_goals"
    t.integer  "guest_goals"
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "points"
  end

  add_index "tipps", ["game_id"], :name => "index_tipps_on_game_id"
  add_index "tipps", ["user_id"], :name => "index_tipps_on_user_id"

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

  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["deactivated"], :name => "index_users_on_deactivated"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
