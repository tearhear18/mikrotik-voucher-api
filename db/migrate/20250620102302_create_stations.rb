class CreateStations < ActiveRecord::Migration[8.0]
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.string :prefix, null: false
      t.timestamps

      t.index :prefix, unique: true
    end
  end
end
