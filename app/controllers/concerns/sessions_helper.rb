module SessionsHelper
  
  private 

  def must_be_authenticated
    user = User.find_by_id(session[:id] || 0)
    if user.nil?
      session.clear
      redirect_to new_session_path
    else
      @current_user = user
    end
  end

  def check_permissions
    return true if current_user.superb?
    raise UserError.new('Not Allowed', unauthorized_index_path) if current_user.abilities.nil? 

    permissions = current_user.abilities[params[:controller]]
    raise UserError.new('Not Allowed', unauthorized_index_path) if permissions.nil?

    allowed_action = permissions.keys
    return true if allowed_action.include? params[:action]

    raise UserError.new('Not Allowed', unauthorized_index_path)
  end
end