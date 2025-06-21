class VoucherJob < ApplicationJob
  queue_as :default

  def perform(code)
    Voucher.process_voucher(code)
  end
end
