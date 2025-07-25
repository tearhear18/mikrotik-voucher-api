module SessionsHelper
  
  def current_user
    user = User.find_by_id(session[:user_id] || 0)
    if user
      @current_user = user
    else
      @current_user = nil
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def must_be_authenticated
    return if logged_in?
    
    session.clear
    redirect_to new_session_path, alert: 'Please log in to continue.'
  end

  def current_user_vouchers
    Voucher.joins(station: :router).where(routers: { user: current_user })
  end
end