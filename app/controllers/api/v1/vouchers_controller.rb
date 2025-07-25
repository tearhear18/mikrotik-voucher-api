class Api::V1::VouchersController < Api::V1::BaseController
  def process
    voucher = VoucherService.process_voucher(params[:code])
    
    if voucher
      render_success({
        voucher: voucher_data(voucher),
        message: 'Voucher processed successfully'
      }, status: :created)
    else
      render_error('Voucher already exists or invalid code')
    end
  end

  def show
    voucher = Voucher.find_by!(code: params[:id])
    render_success(voucher: voucher_data(voucher))
  end

  def create
    voucher_params = params.require(:voucher).permit(:code, :station_id)
    station = Station.find(voucher_params[:station_id])
    
    voucher = Voucher.new(
      code: voucher_params[:code],
      station: station,
      amount: VoucherService.new.calculate_amount(voucher_params[:code])
    )
    
    if voucher.save
      render_success({
        voucher: voucher_data(voucher),
        message: 'Voucher created successfully'
      }, status: :created)
    else
      render_error(voucher.errors.full_messages.join(', '), status: :unprocessable_entity)
    end
  end

  private

  def voucher_data(voucher)
    {
      id: voucher.id,
      code: voucher.code,
      amount: voucher.amount,
      is_collected: voucher.is_collected,
      station_name: voucher.station_name,
      hours_purchased: voucher.hours_purchased,
      created_at: voucher.created_at,
      collected_at: voucher.collected_at
    }
  end
end