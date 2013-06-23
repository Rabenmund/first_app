class AddColumnPointsToTipp < ActiveRecord::Migration
  def change
    add_column :tipps, :points, :integer
  end
end
