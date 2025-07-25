class Voucher < ApplicationRecord
  belongs_to :station
  belongs_to :hotspot_profile, optional: true
  
  validates :code, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :station, presence: true

  # Scopes for better querying
  scope :collected, -> { where(is_collected: true) }
  scope :not_collected, -> { where(is_collected: false) }
  scope :recent, -> { order("vouchers.created_at DESC") }
  scope :by_station, ->(station) { where(station: station) }
  scope :by_date_range, ->(start_date, end_date) { where("vouchers.created_at BETWEEN ? AND ?", start_date, end_date) }
  scope :today, -> { where("vouchers.created_at >= ? AND vouchers.created_at <= ?", Time.current.beginning_of_day, Time.current.end_of_day) }

  # Delegates for easier access
  delegate :name, to: :station, prefix: true
  delegate :router, to: :station
  delegate :user, to: :router

  BASE_HOUR_RATE = 3
  BASE_PRICE = 5.0

  def calculate_amount
    return hotspot_profile_amount if hotspot_profile.present?
    
    # Extract the numeric part of the code for legacy calculation
    numeric_part = extract_numeric_part
    return 0 if numeric_part.zero?

    (numeric_part.to_f / BASE_HOUR_RATE * BASE_PRICE).to_d
  end

  def collect!
    update(is_collected: true, collected_at: Time.current)
  end

  def uncollect!
    update(is_collected: false, collected_at: nil)
  end

  def hours_purchased
    return hotspot_profile.rate_limit if hotspot_profile.present?
    
    # Legacy calculation based on code
    extract_numeric_part
  end

  def status
    is_collected? ? 'Collected' : 'Available'
  end

  def collected?
    is_collected?
  end

  private

  def extract_numeric_part
    code.split("-").last[0].to_i
  end

  def hotspot_profile_amount
    # Calculate amount based on hotspot profile
    # This should be customized based on your business logic
    hotspot_profile.rate_limit.to_f * BASE_PRICE
  end
end
