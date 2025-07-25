class StationsController < ApplicationController
  before_action :set_router, only: [:create, :show]
  before_action :set_station, only: [:show]

  def index
    @stations = current_user_stations
    stats_service = StatisticsService.new(current_user)
    
    @dashboard_stats = stats_service.dashboard_stats
    @todays_vouchers = @dashboard_stats[:todays_vouchers]
    @online = @dashboard_stats[:online_users]
    @voucher_sales = @dashboard_stats[:voucher_sales]
    @per_station_daily_sales = @dashboard_stats[:per_station_daily_sales]
  end

  def create
    @station = @router.stations.build(station_params)
    
    if @station.save
      redirect_to @router, notice: 'Station was successfully created.'
    else
      redirect_to @router, alert: build_error_message(@station)
    end
  end

  def show
    @recent_vouchers = @station.recent_vouchers
    @daily_sales = @station.daily_sales
    @commission = @station.commission
  end

  private

  def set_router
    @router = current_user.routers.find(params[:router_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to routers_path, alert: 'Router not found.'
  end

  def set_station
    @station = @router.stations.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to @router, alert: 'Station not found.'
  end

  def current_user_stations
    Station.joins(:router).where(routers: { user: current_user })
  end

  def station_params
    params.require(:station).permit(:name, :prefix, :commission_rate)
  end

  def build_error_message(station)
    "Failed to create station: #{station.errors.full_messages.join(', ')}"
  end
end
