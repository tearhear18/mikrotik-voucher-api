class AddRouterRawData < ActiveRecord::Migration[8.0]
  def change
    add_column :routers, :raw_data, :jsonb, default: {}, null: false
  end
end
