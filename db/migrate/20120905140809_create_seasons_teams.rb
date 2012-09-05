class CreateSeasonsTeams < ActiveRecord::Migration
  def change
    create_table :seasons_teams, id: false do |t|
      t.integer :season_id
      t.integer :team_id
    end
  end
end
