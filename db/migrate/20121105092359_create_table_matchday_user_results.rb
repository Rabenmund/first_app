class CreateTableMatchdayUserResults < ActiveRecord::Migration
  def change
    create_table :matchday_user_results do |t|
      t.integer :matchday_id
      t.integer :user_id
      t.integer :points

      t.timestamps
    end
  end
end
