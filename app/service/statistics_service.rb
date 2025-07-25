class StatisticsService
  TIMEZONE = "Asia/Manila".freeze

  def initialize(user = nil)
    @user = user
  end

  def dashboard_stats
    {
      todays_vouchers: todays_vouchers,
      online_users: recent_online_users,
      voucher_sales: recent_voucher_sales,
      per_station_daily_sales: per_station_daily_sales
    }
  end

  def todays_vouchers
    start_of_day = Time.current.in_time_zone(TIMEZONE).beginning_of_day
    end_of_day = Time.current.in_time_zone(TIMEZONE).end_of_day

    voucher_scope.where(created_at: start_of_day..end_of_day)
  end

  def recent_online_users(limit: 60)
    LoginCounter
      .last(limit)
      .map do |entry|
        time = entry.created_at.in_time_zone(TIMEZONE)
        [time, entry.count]
      end
  end

  def recent_voucher_sales(days: 10)
    voucher_scope
      .where("created_at >= ?", days.days.ago)
      .group_by_day(:created_at, time_zone: TIMEZONE)
      .sum(:amount)
  end

  def per_station_daily_sales(days: 10)
    today = Time.current.in_time_zone(TIMEZONE).strftime("%Y-%m-%d")
    
    raw_data = voucher_scope
                .where("created_at >= ?", days.days.ago)
                .group(:station_id)
                .group_by_day(:created_at, time_zone: TIMEZONE)
                .sum(:amount)

    raw_data.each_with_object({}) do |((station_id, date), price), result|
      station = Station.find(station_id)
      agent_name = station.name
      
      result[agent_name] ||= {}
      if today.to_s == date.to_s
        result[agent_name]["Today"] = price
      else
        result[agent_name][date] = price
      end
    end
  end

  def station_commission(station)
    total_amount = station.vouchers.not_collected.sum(:amount)
    commission_rate = station.commission_rate || 0.3
    (total_amount * commission_rate).to_d
  end

  private

  def voucher_scope
    if @user
      Voucher.joins(station: :router).where(routers: { user: @user })
    else
      Voucher.all
    end
  end
end