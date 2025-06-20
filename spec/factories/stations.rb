FactoryBot.define do
  factory :station do
    sequence(:name) { |n| "Station #{n}" }
    sequence(:prefix) { |n| "S#{n}" }
  end
end