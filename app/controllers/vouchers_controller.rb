class VouchersController < ApplicationController
  before_action :set_voucher, only: [:show, :collect, :uncollect]

  def index
    @vouchers = current_user_vouchers.includes(:station)
                                   .order(created_at: :desc)
                                   .page(params[:page])
                                   .per(20)
    
    # Calculate totals from all vouchers, not just the current page
    all_vouchers = current_user_vouchers
    @total_amount = all_vouchers.sum(:amount)
    @collected_amount = all_vouchers.collected.sum(:amount)
    @uncollected_amount = all_vouchers.not_collected.sum(:amount)
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
    @hotspot_profile = HotspotProfile.find(voucher_params[:hotspot_profile_id])
    
    result = VoucherService.create_vouchers(
      station: @station,
      hotspot_profile: @hotspot_profile,
      limit_update: voucher_params[:limit_update],
      quantity: voucher_params[:quantity].to_i
    )

    if result[:success_count] > 0
      notice_message = "#{result[:success_count]} voucher(s) generated successfully."
      notice_message += " #{result[:errors].size} failed." if result[:errors].any?
      redirect_to router_station_path(@router, @station), notice: notice_message
    else
      error_message = result[:errors].any? ? result[:errors].join('; ') : 'Failed to generate vouchers.'
      redirect_to router_station_path(@router, @station), alert: error_message
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
    params.require(:voucher).permit(:hotspot_profile_id, :limit_update, :quantity)
  end
end
