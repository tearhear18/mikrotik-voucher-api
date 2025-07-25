class Station < ApplicationRecord
  belongs_to :router
  has_many :vouchers, dependent: :destroy
  has_many :station_documents, dependent: :destroy
  
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :prefix, presence: true, uniqueness: true, length: { minimum: 2, maximum: 10 },
            format: { with: /\A[A-Z0-9]+\z/, message: "must contain only uppercase letters and numbers" }
  validates :commission_rate, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :router, presence: true

  delegate :name, to: :router, prefix: true
  delegate :user, to: :router

  # Scopes for better querying
  scope :by_user, ->(user) { joins(:router).where(routers: { user: user }) }
  scope :with_vouchers, -> { includes(:vouchers) }
  scope :active, -> { where(active: true) }

  def commission
    # Calculate commission based on the commission_rate attribute
    total_amount = vouchers.not_collected.sum(:amount)
    (total_amount * (commission_rate / 100.0)).to_d
  end

  def total_voucher_amount
    vouchers.sum(:amount)
  end

  def collected_voucher_amount
    vouchers.collected.sum(:amount)
  end

  def uncollected_voucher_amount
    vouchers.not_collected.sum(:amount)
  end

  def voucher_count
    vouchers.count
  end

  def recent_vouchers(limit = 10)
    vouchers.order(created_at: :desc).limit(limit)
  end
end
