class VoucherService
  class InvalidVoucherError < StandardError; end
  class StationNotFoundError < StandardError; end

  BASE_HOUR_RATE = 3
  BASE_PRICE = 5.0

  def self.process_voucher(code)
    new.process_voucher(code)
  end

  def self.update_all_amounts
    new.update_all_amounts
  end

  def initialize
  end

  def process_voucher(code)
    return nil if Voucher.exists?(code: code)

    station = find_station_by_code(code)
    raise StationNotFoundError, "Station not found for code: #{code}" unless station

    voucher = Voucher.new(code: code, station: station)
    voucher.amount = calculate_amount(code)
    
    if voucher.save
      voucher
    else
      raise InvalidVoucherError, "Failed to save voucher: #{voucher.errors.full_messages.join(', ')}"
    end
  end

  def update_all_amounts
    Voucher.find_each do |voucher|
      new_amount = calculate_amount(voucher.code)
      voucher.update(amount: new_amount) if voucher.amount != new_amount
    end
  end

  def calculate_amount(code)
    # Extract the numeric part of the code
    numeric_part = extract_numeric_part(code)
    return 0 if numeric_part.zero?

    (numeric_part.to_f / BASE_HOUR_RATE * BASE_PRICE).to_d
  end

  private

  def find_station_by_code(code)
    prefix = extract_prefix(code)
    Station.find_by(prefix: prefix)
  end

  def extract_prefix(code)
    code.split("-").first
  end

  def extract_numeric_part(code)
    code.split("-").last[0].to_i
  end
end