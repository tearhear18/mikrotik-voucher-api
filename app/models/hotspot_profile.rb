class HotspotProfile < ApplicationRecord
  belongs_to :router
  has_many :vouchers, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { scope: :router_id }
  validates :rate_limit, presence: true
  validates :router, presence: true

  DEFAULT_SETTING = {
    
  }

  # Creates this profile on the associated router
  def create_on_router
    router.configuration_service.create_hotspot_profile(self)
  end

  # Removes this profile from the associated router
  def remove_from_router
    router.configuration_service.remove_hotspot_profile(self)
  end

  # Override destroy to remove from router first
  def destroy
    return false unless remove_from_router
    super
  end
end
