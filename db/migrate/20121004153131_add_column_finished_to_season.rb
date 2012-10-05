class AddColumnFinishedToSeason < ActiveRecord::Migration
  def change
    add_column :seasons, :finished, :boolean
  end
end
