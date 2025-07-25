class VoucherJob < ApplicationJob
  queue_as :default

  def perform(voucher_id)
    voucher = Voucher.find_by(id: voucher_id)
    return unless voucher
    station = voucher.station
    router = station.router
    profile = voucher.hotspot_profile&.name || 'default'
    time_limit = voucher.limit_update || '1d'
    username = voucher.code
    RouterConfigurationService.for_router(router).mikrotik_service.add_user(
      username: username,
      profile: profile,
      time_limit: time_limit
    )
  end
end
