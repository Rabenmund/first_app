class DropTableRelationships < ActiveRecord::Migration
  def up
    drop_table :relationships
  end

end
