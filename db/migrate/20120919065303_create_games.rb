class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_goals
      t.integer :guest_goals
      t.integer :home_id
      t.integer :guest_id
      t.integer :matchday_id
      t.datetime :date

      t.timestamps
    end
  end
end
