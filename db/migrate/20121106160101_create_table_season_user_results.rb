class CreateTableSeasonUserResults < ActiveRecord::Migration
  def change
    create_table :season_user_results do |t|
      t.integer :season_id
      t.integer :user_id
      t.integer :points

      t.timestamps
    end
  end
end
