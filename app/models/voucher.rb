class Voucher < ApplicationRecord
  belongs_to :station

  validates :code, presence: true, uniqueness: true

  def self.process_voucher(code)
    voucher = find_by(code: code)

    return unless voucher.nil?

    prefix = code.split("-").first
    station = Station.find_by(prefix: prefix)

    return unless station.present?

    create(code: code, station: station)
  end
end
