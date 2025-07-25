class SessionsController < ApplicationController
  skip_before_action :must_be_authenticated
  
  def new
    redirect_to root_path if session[:id].present?
  end

  def create
    user = User.find_by(username: session_params[:username])
    raise UserError.new('Invalid Account', new_session_path) unless user&.authenticate(session_params[:password])

    session[:id] = user.id
    redirect_to root_path
  end

  def logout
    session.clear
    redirect_to root_path
  end

  private 

  def session_params 
    params.permit(:username, :password)
  end
end
