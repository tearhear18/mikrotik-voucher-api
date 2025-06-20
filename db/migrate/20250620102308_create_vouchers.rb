class CreateVouchers < ActiveRecord::Migration[8.0]
  def change
    create_table :vouchers do |t|
      t.string :code, null: false
      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.belongs_to :station, null: false, foreign_key: true, index: true
      t.timestamps

      t.index :code, unique: true
    end
  end
end
