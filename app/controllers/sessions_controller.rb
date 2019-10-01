class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      # cookiesを生成
      if params[:session][:remember_me] == '1' # checkboxはsessionハッシュに内包
        remember_token = SecureRandom.urlsafe_base64 # ランダムな文字列生成
        user.update_attribute(:remember_digest, User.digest(remember_token)) # DBにハッシュ化remenber_tokenを保存
        cookies.permanent.signed[:user_id] = user.id # cookiesに暗号化user_idを記録
        cookies.permanent[:remember_token] = remember_token # cookiesにremembe_tokenを保存
      end
      redirect_to session[:forwarding_url] || user
      session[:forwarding_url] = nil
    else
      flash.now[:danger] = "メールアドレスかパスワードが正しくありません"
      render 'new'
    end
  end

  def destroy
    if log_in?
      current_user.update_attribute(:remember_digest, nil) # DB情報削除
      cookies.delete(:user_id) # cookies 2つ削除
      cookies.delete(:remember_token) # cookies 2つ削除
      session.delete(:user_id)
      @current_user = nil
    end
      redirect_to root_url # 別タブ用
  end

end
