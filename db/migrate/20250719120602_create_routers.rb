class CreateRouters < ActiveRecord::Migration[8.0]
  def change
    create_table :routers do |t|
      t.string :name, null: false
      t.string :host_name, null: false
      t.string :username, null: false
      t.string :password, null: false
      t.belongs_to :user, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
