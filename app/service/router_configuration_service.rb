class RouterConfigurationService
  DEFAULT_CONFIG = {
    timeout: 10,
    auth_methods: ['password'],
    verbose: :error
  }.freeze

  def self.for_router(router)
    new(router)
  end

  def initialize(router)
    @router = router
  end

  def connection_params
    {
      host: @router.host_name,
      user: @router.username,
      password: @router.password,
      port: @router.respond_to?(:port) && @router.port.present? ? @router.port : 22
    }
  end

  def ssh_options
    DEFAULT_CONFIG
  end

  def mikrotik_service
    @mikrotik_service ||= MikrotikService.new(**connection_params)
  end

  def test_connection
    service = mikrotik_service
    service.fetch_router_data
    true
  rescue MikrotikService::ConnectionError, MikrotikService::CommandError
    false
  ensure
    service&.disconnect
  end

  def execute_with_service(&block)
    service = mikrotik_service
    result = yield(service)
    result
  ensure
    service&.disconnect
  end

  def sync_hotspot_profiles
    begin
      profiles = mikrotik_service.fetch_hotspot_profiles
      return false unless profiles.is_a?(Array)
      # Remove all existing profiles and re-create from fetched data
      @router.hotspot_profiles.destroy_all
      profiles.each do |profile_data|
        @router.hotspot_profiles.create(
          name: profile_data[:name],
          rate_limit: profile_data[:rate_limit]
        )
      end
      true
    rescue => e
      Rails.logger.error "Failed to sync hotspot profiles: #{e.message}"
      false
    end
  end
end