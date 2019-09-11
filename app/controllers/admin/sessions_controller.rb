class Admin::SessionsController < ApplicationController
  def home
  end
  def new
  end
  def create
    admin = Admin.find_by(email: params[:session][:email].downcase)
    if admin && admin.authenticate(params[:session][:password])
      session[:admin_id] = admin.id
      redirect_to admin_root_path
    else
      flash.now[:danger] = "メールアドレスかパスワードが正しくありません"
      render 'new'
    end
  end
end
