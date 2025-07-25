module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def must_be_authenticated
    return if logged_in?
    
    session.clear
    redirect_to new_session_path, alert: 'Please log in to continue.'
  end

  def log_in(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def require_permission(action = nil)
    return true if current_user&.superb?
    
    controller_name = params[:controller]
    action_name = action || params[:action]
    
    unless has_permission?(controller_name, action_name)
      raise UserError.new('Access denied. You do not have permission to perform this action.', root_path)
    end
    
    true
  end

  def has_permission?(controller, action)
    return false unless current_user&.abilities
    
    permissions = current_user.abilities[controller]
    return false unless permissions
    
    permissions.keys.include?(action)
  end
end