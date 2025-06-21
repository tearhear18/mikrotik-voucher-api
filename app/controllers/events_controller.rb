class EventsController < ApplicationController
  
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def create
    @event = Event.new(event_params)
    if @event.save
      if @event.mode == "login"
        VoucherJob.perform_later(@event.code)
      end
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:code, :mac, :mode)
  end
end
