class Station < ApplicationRecord
  validates :name, presence: true
  validates :prefix, presence: true, uniqueness: true

  has_many :vouchers, dependent: :destroy
  belongs_to :router
  delegate :name, to: :router, prefix: true
  
  def commission
    # Assuming commission is a fixed percentage of the total amount
    # This can be adjusted based on business logic
    total_amount = vouchers.not_collected.sum(:amount)
    (total_amount * 0.3).to_d
  end
end
