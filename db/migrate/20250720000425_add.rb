class Add < ActiveRecord::Migration[8.0]
  def change
    add_reference :stations, :router, null: false, foreign_key: true
  end
end
