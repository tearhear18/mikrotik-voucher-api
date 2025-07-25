class Router < ApplicationRecord
  include BandwidthOptions
  has_many :stations, dependent: :destroy
  has_many :hotspot_profiles, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
  validates :host_name, presence: true, format: { with: /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/, message: "must be a valid IP address" }
  validates :username, presence: true
  validates :password, presence: true
  validates :port, numericality: { only_integer: true, greater_than: 0, less_than: 65536 }, allow_nil: true

  def configuration_service
    @configuration_service ||= RouterConfigurationService.for_router(self)
  end

  def connect
    configuration_service.mikrotik_service
  end

  def test_connection
    configuration_service.test_connection
  end

  def fetch_data
    configuration_service.execute_with_service do |service|
      self.raw_data ||= {}
      self.raw_data[:device_info] = service.fetch_router_data
      self.raw_data[:last_updated] = Time.current
      save!
      true
    end
  rescue MikrotikService::ConnectionError, MikrotikService::CommandError => e
    Rails.logger.error "Router #{name} connection failed: #{e.message}"
    false
  end

  def connection_status
    return 'unknown' unless raw_data&.dig(:last_updated)
    
    last_update = Time.parse(raw_data[:last_updated]) rescue nil
    return 'unknown' unless last_update
    
    if last_update > 5.minutes.ago
      'connected'
    elsif last_update > 1.hour.ago
      'warning'
    else
      'disconnected'
    end
  end

  def device_info
    raw_data&.dig(:device_info) || {}
  end
end
