class StationsController < ApplicationController
  def index
    @stations = Station.all
    time_zone = "Asia/Manila"
    today = Time.current.in_time_zone(time_zone).strftime("%Y-%m-%d")

    start_of_day = Time.now.in_time_zone(time_zone).beginning_of_day
    end_of_day   = Time.now.in_time_zone(time_zone).end_of_day

    @todays_vouchers = Voucher.where(created_at: start_of_day..end_of_day)

    @online = LoginCounter
                .last(60)
                .map do |entry|
                  time = entry.created_at.in_time_zone("Asia/Manila")
                  [time, entry.count]
                end
    
    raw_data = Voucher.where("created_at >= ?", 10.days.ago).group(:station_id).group_by_day(:created_at, time_zone: time_zone).sum(:amount)
    @voucher_sales = Voucher.where("created_at >= ?", 10.days.ago)
                         .group_by_day(:created_at, time_zone: time_zone)
                         .sum(:amount)
    
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

  def create 
    @router = current_user.routers.find(params[:router_id])
    @station = @router.stations.new(station_params)
    if @station.save
      redirect_to @router, notice: 'Station was successfully created.'
    else
      redirect_to @router, alert: "Failed to fetch router data: #{e.message}"
    end
  end

  def show
    @router = current_user.routers.find(params[:router_id])
    @station = @router.stations.find(params[:id])
  end

  private 

  def station_params
    params.require(:station).permit(:name, :prefix, :router_id)
  end
end
