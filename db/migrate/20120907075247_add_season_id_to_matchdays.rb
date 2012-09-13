class AddSeasonIdToMatchdays < ActiveRecord::Migration
  def change
    add_column :matchdays, :season_id, :integer
  end
end
