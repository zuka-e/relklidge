module SessionsHelper

  def current_user
    if session[:user_id] # find_by -> x例外=>nil
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id] # .signed -> 復号
      user = User.find_by(id: cookies.signed[:user_id])
      return false if remember_digest.nil? # 別ブラウザ用エラー防止
      if user && BCrypt::Password.new(user.remember_digest).is_password?(cookies[:remember_token])
        log_in user # ブラウザにcookiesあれば常にログイン状態
        @current_user = user # remember_digest存在 -> ログアウト不可を確認
      end
    end
  end
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_admin
    if session[:admin_id]
      @current_admin ||= Admin.find_by(id: session[:admin_id])
    end
  end

  def log_in?
    !current_user.nil?
  end
  def admin_log_in?
    !current_admin.nil?
  end

end
