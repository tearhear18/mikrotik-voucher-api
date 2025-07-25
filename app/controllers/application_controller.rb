class ApplicationController < ActionController::Base
  include Authentication
  
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  before_action :must_be_authenticated
  
  rescue_from UserError, with: :user_error_occurred

  private

  def user_error_occurred(exception)
    flash[:alert] = exception.message
    redirect_to exception.path
  end
end
