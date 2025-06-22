class StationsController < ApplicationController
  def index
    @stations = Station.all    
    time_zone = "Asia/Manila"
    today = Time.zone.now.to_date.strftime('%Y-%m-%d')
    @event_counts = Event
      .where(mode: "login", created_at: 24.hours.ago..Time.current)
      .group_by_hour(
        :created_at,
        format: "%Y-%m-%d %H:%M",
        series: false,
        time_zone: time_zone
      )
      .count    
    raw_data = Voucher.where('created_at >= ?',10.days.ago).group(:station_id).group_by_day(:created_at, time_zone: time_zone).sum(:amount)
    @per_station_daily_sales = raw_data.each_with_object({}) do |((station_id, date), price), result|
      agent_name = Station.find(station_id).name
      result[agent_name] ||= {}
      
      result[agent_name][date] = price
      if today.to_s === date.to_s
        result[agent_name]['Today'] = price
      else
        result[agent_name][date] = price
      end
    end  
  end

  def show
    @station = Station.find(params[:id])
  end
end
