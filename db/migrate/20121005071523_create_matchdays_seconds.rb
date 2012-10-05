class CreateMatchdaysSeconds < ActiveRecord::Migration
  def change
    create_table :matchdays_seconds, id: false do |t|
      t.references :matchday
      t.references :user
    end
    add_index :matchdays_seconds, :matchday_id, null: false
    add_index :matchdays_seconds, :user_id, null: false
  end
end
