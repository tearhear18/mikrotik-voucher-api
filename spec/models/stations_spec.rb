require 'rails_helper'

RSpec.describe Station, type: :model do
  it "has a valid factory" do
    expect(build(:station)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:station, name: nil)).not_to be_valid
  end

  it "is invalid without a prefix" do
    expect(build(:station, prefix: nil)).not_to be_valid
  end

  it "enforces unique prefixes" do
    create(:station, prefix: "ABC")
    expect(build(:station, prefix: "ABC")).not_to be_valid
  end
end