class ApplicationController < ActionController::Base

  include SessionsHelper
  before_action :admin_log_in_request

  private

    def admin_log_in_request
      if request.fullpath.match?(/^\/admin\/*/) && !request.fullpath.match?(/^\/admin\/login/) && !admin_log_in?
        session[:forwarding_url] = request.original_url # ログイン時に使用
        flash[:danger] = "ログインが必要です"
        redirect_to admin_login_url
      end
    end

end
