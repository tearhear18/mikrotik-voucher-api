class AddLimitUpdateToVouchers < ActiveRecord::Migration[8.0]
  def change
    add_column :vouchers, :limit_update, :string
  end
end
