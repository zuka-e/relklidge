class ActivationsController < ApplicationController

  def edit
    @user = User.find_by(email: params[:email]) # paramsは送信メールのlink_toに
    if @user && BCrypt::Password.new(@user.activation_digest).is_password?(params[:id]) && !@user.is_activated? # 有効なのは一度のみ(不正防止)
      @user.update_attribute(:is_activated, true)
      log_in @user
      flash[:success] = '登録が完了しました'
      redirect_to @user
    else
      flash[:danger] = '無効なリンクです'
      redirect_to root_url
    end
  end

end
