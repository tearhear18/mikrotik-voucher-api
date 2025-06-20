class Voucher < ApplicationRecord
  belongs_to :station

  validates :code, presence: true, uniqueness: true
end
