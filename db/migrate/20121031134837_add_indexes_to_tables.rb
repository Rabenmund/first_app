class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :games, :matchday_id
    add_index :games, :finished
    add_index :games, :date
    add_index :games, :home_id
    add_index :games, :guest_id
    add_index :matchdays, :number
    add_index :matchdays, :date
    add_index :matchdays, :season_id
    add_index :matchdays, :finished
    add_index :microposts, :user_id
    add_index :seasons, :start_date
    add_index :seasons, :end_date
    add_index :seasons, :finished
    add_index :seasons_teams, :season_id
    add_index :seasons_teams, :team_id
    add_index :seasons_users, :season_id
    add_index :seasons_users, :user_id
    add_index :teams, :chars
    add_index :tipps, :user_id
    add_index :tipps, :game_id
    add_index :users, :admin
    add_index :users, :deactivated
  end
end
