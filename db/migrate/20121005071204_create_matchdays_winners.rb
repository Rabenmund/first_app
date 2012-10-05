class CreateMatchdaysWinners < ActiveRecord::Migration
  def change
    create_table :matchdays_winners, id: false do |t|
      t.references :matchday
      t.references :user
    end
    add_index :matchdays_winners, :matchday_id, null: false
    add_index :matchdays_winners, :user_id, null: false
  end
end
