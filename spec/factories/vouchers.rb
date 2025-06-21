FactoryBot.define do
  factory :voucher do
    code { "VOUCHER#{SecureRandom.hex(4).upcase}" }
  end
end
