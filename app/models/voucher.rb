class Voucher < ApplicationRecord
  belongs_to :station

  validates :code, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :collected, -> { where(is_collected: true) }
  scope :not_collected, -> { where(is_collected: false) }
  scope :for_station, ->(station) { where(station: station) }
  scope :recent, -> { order(created_at: :desc) }

  delegate :name, to: :station, prefix: true

  def self.process_voucher(code)
    VoucherService.process_voucher(code)
  rescue VoucherService::StationNotFoundError, VoucherService::InvalidVoucherError
    nil
  end

  def self.update_amount
    VoucherService.update_all_amounts
  end

  def self.find_by_code(code)
    find_by(code: code)
  end

  def calculate_amount
    VoucherService.new.calculate_amount(code)
  end

  def collect!
    update!(is_collected: true, collected_at: Time.current)
  end

  def uncollect!
    update!(is_collected: false, collected_at: nil)
  end

  def collected?
    is_collected?
  end

  def prefix
    code.split("-").first
  end

  def numeric_part
    code.split("-").last[0].to_i
  end

  def hours_purchased
    numeric_part
  end
end
