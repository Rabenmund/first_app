class AddMatchdaysToSeason < ActiveRecord::Migration
  def change
    add_column :seasons, :matchday_ids, :integer
  end
end
