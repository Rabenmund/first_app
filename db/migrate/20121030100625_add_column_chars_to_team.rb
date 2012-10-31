class AddColumnCharsToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :chars, :string
  end
end
