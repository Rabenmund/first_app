class CreateTipps < ActiveRecord::Migration
  def change
    create_table :tipps do |t|
      t.integer :home_goals
      t.integer :guest_goals
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end
  end
end
