class AddPortToRouter < ActiveRecord::Migration[8.0]
  def change
    add_column :routers, :port, :integer, null: true unless column_exists?(:routers, :port)
  end
end
