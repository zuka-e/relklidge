class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to session[:forwarding_url] || user
    else
      flash.now[:danger] = "メールアドレスかパスワードが正しくありません"
      render 'new'
    end
  end

  def destroy
    if log_in?
      session.delete(:user_id)
      @current_user = nil
      redirect_to root_url
    end
  end

end
