class AddIsCollectedToVoucher < ActiveRecord::Migration[8.0]
  def change
    add_column :vouchers, :is_collected, :boolean, default: false
  end
end
