class StationsController < ApplicationController
  def index
    @stations = Station.all
    time_zone = "Asia/Manila"
    today = Time.current.in_time_zone(time_zone).strftime("%Y-%m-%d")

    start_of_day = Time.now.in_time_zone(time_zone).beginning_of_day
    end_of_day   = Time.now.in_time_zone(time_zone).end_of_day

    @todays_vouchers = Voucher.where(created_at: start_of_day..end_of_day)

    @login_counts = Event
      .where(mode: "login", created_at: 24.hours.ago..Time.current)
      .group_by_hour(:created_at, format: "%Y-%m-%d %H:%M", series: false, time_zone: time_zone)
      .count


    @logout_counts = Event
      .where(mode: "logout", created_at: 24.hours.ago..Time.current)
      .group_by_hour(:created_at, format: "%Y-%m-%d %H:%M", series: false, time_zone: time_zone)
      .count
      
    raw_data = Voucher.where("created_at >= ?", 10.days.ago).group(:station_id).group_by_day(:created_at, time_zone: time_zone).sum(:amount)
    
    
    @per_station_daily_sales = raw_data.each_with_object({}) do |((station_id, date), price), result|
      agent_name = Station.find(station_id).name
      result[agent_name] ||= {}
      if today.to_s === date.to_s
        result[agent_name]["Today"] = price
      else
        result[agent_name][date] = price
      end
    end
  end

  def show
    @station = Station.find(params[:id])
  end
end
