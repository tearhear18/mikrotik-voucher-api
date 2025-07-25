class DashboardController < ApplicationController
  def index
    @router_count = current_user.routers.count
    @station_count = Station.by_user(current_user).count
    @voucher_count = current_user_vouchers.count
    @revenue_today = current_user_vouchers_today.sum(:amount)
    
    @voucher_sales = voucher_sales_data
    @recent_vouchers = recent_vouchers_data
  end

  private

  def current_user_vouchers_today
    current_user_vouchers.where("vouchers.created_at >= ? AND vouchers.created_at <= ?", 
                                Time.current.beginning_of_day, 
                                Time.current.end_of_day)
  end

  def voucher_sales_data
    current_user_vouchers
      .where("vouchers.created_at >= ?", 10.days.ago)
      .group_by_day("vouchers.created_at")
      .sum(:amount)
  end

  def recent_vouchers_data
    current_user_vouchers
      .order("vouchers.created_at DESC")
      .limit(5)
      .includes(:station, :hotspot_profile)
  end
end
