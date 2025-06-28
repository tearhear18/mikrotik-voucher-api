class LoginCountersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create ]
  
  def create 
    @login_counter = LoginCounter.new(login_counter_params)
    if @login_counter.save
      render json: @login_counter, status: :created
    else
      render json: @login_counter.errors, status: :unprocessable_entity
    end
  end

  def login_counter_params
    params.require(:login_counter).permit(:count)
  end
end
