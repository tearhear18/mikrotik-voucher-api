class AddMissingColumns < ActiveRecord::Migration[8.0]
  def change
    # Add collected_at column to vouchers
    add_column :vouchers, :collected_at, :datetime, null: true
    
    # Add commission_rate to stations
    add_column :stations, :commission_rate, :decimal, precision: 5, scale: 4, default: 0.3
    
    # Add raw_data to routers for storing connection info
    add_column :routers, :raw_data, :text, null: true
    
    # Add missing columns to hotspot_profiles if they don't exist
    unless column_exists?(:hotspot_profiles, :name)
      add_column :hotspot_profiles, :name, :string, null: false
    end
    
    unless column_exists?(:hotspot_profiles, :rate_limit)
      add_column :hotspot_profiles, :rate_limit, :string, null: true
    end
    
    unless column_exists?(:hotspot_profiles, :shared_users)
      add_column :hotspot_profiles, :shared_users, :integer, default: 1
    end
    
    unless column_exists?(:hotspot_profiles, :idle_timeout)
      add_column :hotspot_profiles, :idle_timeout, :string, default: 'none'
    end
    
    unless column_exists?(:hotspot_profiles, :router_id)
      add_column :hotspot_profiles, :router_id, :integer, null: false
      add_foreign_key :hotspot_profiles, :routers
    end
    
    # Add indexes for better performance
    add_index :vouchers, :collected_at
    add_index :vouchers, [:station_id, :created_at]
    add_index :stations, :prefix, unique: true unless index_exists?(:stations, :prefix)
    add_index :hotspot_profiles, [:router_id, :name], unique: true
  end
end