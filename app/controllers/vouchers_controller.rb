class VouchersController < ApplicationController
  before_action :set_voucher, only: [:show, :collect, :uncollect]

  def index
    @vouchers = current_user_vouchers.includes(:station)
                                   .page(params[:page])
                                   .per(20)
    
    @total_amount = @vouchers.sum(:amount)
    @collected_amount = @vouchers.collected.sum(:amount)
    @uncollected_amount = @vouchers.not_collected.sum(:amount)
  end

  def show
  end

  def new
    @station = Station.find(params[:station_id])
    @router = @station.router
    @voucher = Voucher.new
  end

  def create
    @station = Station.find(params[:station_id])
    @router = @station.router
    @hotspot_profile = HotspotProfile.find(params[:voucher][:hotspot_profile_id])
    limit_update = params[:voucher][:limit_update]
    quantity = params[:voucher][:quantity].to_i
    vouchers = []
    quantity.times do |i|
      code = "#{@station.prefix}-#{SecureRandom.hex(3).upcase}"
      voucher = Voucher.new(
        code: code,
        station: @station,
        hotspot_profile: @hotspot_profile,
        limit_update: limit_update
      )
      voucher.amount = voucher.calculate_amount
      vouchers << voucher if voucher.save
    end
    if vouchers.any?
      redirect_to router_station_path(@router, @station), notice: "#{vouchers.size} vouchers generated."
      vouchers.each do |voucher|
        VoucherJob.perform_later(voucher.id)
      end
    else
      redirect_to router_station_path(@router, @station), alert: 'Failed to generate vouchers.'
    end
  end

  def process_code
    voucher = VoucherService.process_voucher(params[:code])
    
    if voucher
      render json: { success: true, voucher: voucher }, status: :created
    else
      render json: { success: false, error: 'Voucher already exists or invalid code' }, status: :unprocessable_entity
    end
  end

  def collect
    if @voucher.collect!
      redirect_to @voucher, notice: 'Voucher marked as collected.'
    else
      redirect_to @voucher, alert: 'Failed to mark voucher as collected.'
    end
  end

  def uncollect
    if @voucher.uncollect!
      redirect_to @voucher, notice: 'Voucher marked as uncollected.'
    else
      redirect_to @voucher, alert: 'Failed to mark voucher as uncollected.'
    end
  end

  private

  def set_voucher
    @voucher = current_user_vouchers.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to vouchers_path, alert: 'Voucher not found.'
  end

  def current_user_vouchers
    Voucher.joins(station: :router).where(routers: { user: current_user })
  end

  def voucher_params
    params.require(:voucher).permit(:code)
  end
end
