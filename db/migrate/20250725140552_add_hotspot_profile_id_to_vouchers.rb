class AddHotspotProfileIdToVouchers < ActiveRecord::Migration[8.0]
  def change
    add_reference :vouchers, :hotspot_profile, null: false, foreign_key: true
  end
end
