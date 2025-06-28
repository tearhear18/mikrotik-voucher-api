class LoginCountersController < ApplicationController
  def create 
    @login_counter = LoginCounter.new(login_counter_params)
    if @login_counter.save
      render json: @login_counter, status: :created
    else
      render json: @login_counter.errors, status: :unprocessable_entity
    end
  end
end
