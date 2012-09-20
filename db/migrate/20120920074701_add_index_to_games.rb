class AddIndexToGames < ActiveRecord::Migration
  def change
    add_index :games, [:home_id, :guest_id], name: 'pair'
  end
end
