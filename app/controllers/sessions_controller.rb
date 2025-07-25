class SessionsController < ApplicationController
  skip_before_action :must_be_authenticated
  
  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(username: session_params[:username])
    
    if user&.authenticate(session_params[:password])
      log_in(user)
      redirect_to root_path, notice: 'Successfully logged in.'
    else
      flash.now[:alert] = 'Invalid username or password.'
      render :new, status: :unprocessable_entity
    end
  end

  def logout
    log_out
    redirect_to root_path, notice: 'Successfully logged out.'
  end

  private 

  def session_params 
    params.permit(:username, :password)
  end
end
