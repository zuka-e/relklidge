module SessionsHelper

  def current_user
    if session[:user_id] # find_by -> x例外=>nil
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  def current_admin
    if session[:admin_id] # find_by -> x例外=>nil
      @current_admin ||= Admin.find_by(id: session[:admin_id])
    end
  end
  def log_in?
    !current_user.nil? || !current_admin.nil?
  end

end
