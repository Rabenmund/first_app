class RemovePointsFromTipps < ActiveRecord::Migration
  def up
    remove_column :tipps, :points
  end

  def down
    add_column :tipps, :points, :integer
  end
end
