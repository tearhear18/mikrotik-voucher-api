class User < ApplicationRecord
  has_secure_password

  has_many :routers, dependent: :destroy
end
