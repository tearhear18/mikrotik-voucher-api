class Station < ApplicationRecord
  belongs_to :router
  has_many :vouchers, dependent: :destroy

  validates :name, presence: true
  validates :prefix, presence: true, uniqueness: true, format: { with: /\A[A-Z0-9]+\z/, message: "must contain only uppercase letters and numbers" }
  validates :commission_rate, numericality: { greater_than: 0, less_than_or_equal_to: 1 }, allow_nil: true

  delegate :name, to: :router, prefix: true
  
  scope :active, -> { joins(:router) }
  scope :with_vouchers, -> { joins(:vouchers).distinct }

  def commission(use_service: true)
    if use_service
      StatisticsService.new.station_commission(self)
    else
      # Fallback calculation
      total_amount = vouchers.not_collected.sum(:amount)
      rate = commission_rate || 0.3
      (total_amount * rate).to_d
    end
  end

  def total_sales
    vouchers.sum(:amount)
  end

  def total_uncollected_sales
    vouchers.not_collected.sum(:amount)
  end

  def vouchers_count
    vouchers.count
  end

  def recent_vouchers(limit: 10)
    vouchers.recent.limit(limit)
  end

  def daily_sales(date = Date.current)
    start_of_day = date.beginning_of_day
    end_of_day = date.end_of_day
    vouchers.where(created_at: start_of_day..end_of_day).sum(:amount)
  end
end
