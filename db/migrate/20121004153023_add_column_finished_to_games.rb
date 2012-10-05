class AddColumnFinishedToGames < ActiveRecord::Migration
  def change
    add_column :games, :finished, :boolean
  end
end
