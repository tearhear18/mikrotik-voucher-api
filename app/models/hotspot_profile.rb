class HotspotProfile < ApplicationRecord
  include BandwidthOptions

  belongs_to :router

  validates :name, presence: true, uniqueness: { scope: :router_id }
  validates :rate_limit, inclusion: { in: ->(profile) { profile.class.bandwidth_values }, allow_blank: true }
  validates :shared_users, presence: true, numericality: { greater_than: 0 }
  validates :idle_timeout, presence: true

  DEFAULT_SETTINGS = {
    shared_users: 1,
    idle_timeout: 'none',
    rate_limit: nil
  }.freeze

  def self.default_settings
    DEFAULT_SETTINGS
  end

  def create_on_router
    router.configuration_service.execute_with_service do |service|
      service.add_hotspot_user_profile(
        name: name,
        rate_limit: rate_limit,
        shared_users: shared_users,
        idle_timeout: idle_timeout
      )
    end
  rescue MikrotikService::ConnectionError, MikrotikService::CommandError => e
    Rails.logger.error "Failed to create hotspot profile #{name} on router: #{e.message}"
    false
  end

  def display_rate_limit
    bandwidth_display(rate_limit) if rate_limit.present?
  end
end
