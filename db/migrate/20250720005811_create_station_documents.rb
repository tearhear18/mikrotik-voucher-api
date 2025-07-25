class CreateStationDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :station_documents do |t|
      t.belongs_to :station, null: false, foreign_key: true
      t.string :name
      t.timestamps
    end
  end
end
