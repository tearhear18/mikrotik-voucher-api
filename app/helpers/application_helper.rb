module ApplicationHelper
  def current_user_voucher_count
    return 0 unless current_user
    current_user_vouchers.count
  end

  def current_user_station_count
    return 0 unless current_user
    Station.by_user(current_user).count
  end
end
