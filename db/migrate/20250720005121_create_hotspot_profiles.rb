class CreateHotspotProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :hotspot_profiles do |t|
      t.belongs_to :router, null: false, foreign_key: true
      t.string :name, null: false 
      t.string :rate
      t.jsonb :raw_data
      t.timestamps
    end
  end
end
