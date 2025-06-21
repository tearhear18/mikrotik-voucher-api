require 'rails_helper'

RSpec.describe Voucher, type: :model do
  let!(:station) { create(:station) }
  let!(:voucher) { build(:voucher, station: station) }

  it "has a valid factory" do
    expect(voucher).to be_valid
  end

  it "is invalid without a code" do
    voucher.code = nil
    expect(voucher).not_to be_valid
  end

  it "enforces unique codes" do
    create(:voucher, station: station, code: "UNIQUE123")
    voucher.code = "UNIQUE123"
    expect(voucher).not_to be_valid
  end
end
