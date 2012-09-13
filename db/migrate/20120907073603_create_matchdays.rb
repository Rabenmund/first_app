class CreateMatchdays < ActiveRecord::Migration
  def change
    create_table :matchdays do |t|
      t.integer :number
      t.datetime :date

      t.timestamps
    end
  end
end
