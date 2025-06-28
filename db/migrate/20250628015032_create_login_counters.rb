class CreateLoginCounters < ActiveRecord::Migration[8.0]
  def change
    create_table :login_counters do |t|
      t.timestamps
      t.integer :count
    end
  end
end
