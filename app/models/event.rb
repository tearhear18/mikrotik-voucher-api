class Event < ApplicationRecord
  enum :mode, %i[login logout]

  def self.manual_process 
    all.each do |event| 
      next if event.mode == "logout"

      Voucher.process_voucher(event.code)
    end
  end
end
