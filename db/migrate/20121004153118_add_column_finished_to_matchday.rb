class AddColumnFinishedToMatchday < ActiveRecord::Migration
  def change
    add_column :matchdays, :finished, :boolean
  end
end
