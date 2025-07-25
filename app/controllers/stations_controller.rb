class StationsController < ApplicationController
  before_action :set_router, only: [:create, :show]
  before_action :set_station, only: [:show]

  def index
    @stations = Station.by_user(current_user).with_vouchers
    @dashboard_stats = StatisticsService.new(current_user).dashboard_stats
    
    # Extract stats for easier view access
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
      redirect_to @router, alert: @station.errors.full_messages.join(', ')
    end
  end

  def show
    @recent_vouchers = @station.recent_vouchers
    @station_stats = {
      total_amount: @station.total_voucher_amount,
      collected_amount: @station.collected_voucher_amount,
      uncollected_amount: @station.uncollected_voucher_amount,
      voucher_count: @station.voucher_count,
      commission: @station.commission
    }
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

  def station_params
    params.require(:station).permit(:name, :prefix, :commission_rate)
  end
end
