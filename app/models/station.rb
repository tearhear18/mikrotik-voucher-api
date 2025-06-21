class Station < ApplicationRecord
  validates :name, presence: true
  validates :prefix, presence: true, uniqueness: true

  has_many :vouchers, dependent: :destroy
end
