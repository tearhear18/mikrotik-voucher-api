class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :code, null: false
      t.string :mac, null: false
      t.integer :mode
      t.timestamps
    end
  end
end
