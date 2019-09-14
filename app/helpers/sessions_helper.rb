module SessionsHelper

  def current_user
    if session[:user_id] # find_by -> x例外=>nil
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  def log_in?
    !currnet_user.nil?
  end

end
