class ApplicationController < ActionController::Base
  add_flash_types(:danger)

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def is_current_user?(user)
    current_user == user
  end

  helper_method :is_current_user?

  def is_current_user_admin?
    current_user && current_user.admin?
  end

  helper_method :is_current_user_admin?

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to signin_url, notice: 'Please sign in first!'
    end
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_url, status: :see_other, alert: 'Unauthorized! Only Admin Users Allowed'
    end
  end
end
