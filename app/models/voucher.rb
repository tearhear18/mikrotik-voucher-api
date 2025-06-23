class Voucher < ApplicationRecord
  belongs_to :station

  BASE_HOUR_RATE = 3
  BASE_PRICE = 5.0

  scope :collected, -> { where(is_collected: true) }
  scope :not_collected, -> { where(is_collected: false) }
  validates :code, presence: true, uniqueness: true

  def self.process_voucher(code)
    voucher = find_by(code: code)

    return unless voucher.nil?

    prefix = code.split("-").first
    station = Station.find_by(prefix: prefix)

    return unless station.present?

    nv = new(code: code, station: station)
    nv.amount = nv.calculate_amount
    nv.save!
  end

  def self.update_amount
    all.each do |voucher|
      voucher.update(amount: voucher.calculate_amount)
    end
  end

  def self.find_by_code(code)
    find_by(code: code)
  end

  def calculate_amount
    # Extract the numeric part of the code
    num = code.split("-").last[0].to_i

    return 0 if num.zero?

    (num / BASE_HOUR_RATE * BASE_PRICE).to_d
  end
end
