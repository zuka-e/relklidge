class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "登録が完了しました"
      redirect_to @user
    else
      render 'new'
    end
  end
  def show
  end

  def edit
  end

  def withdrawal
    @user = User.find(params[:id])
  end
  def quit
    @user = User.find(params[:id])
    @user.is_quit = true
    if @user.save
      flash[:warning] = "退会処理が正常に完了しました"
      redirect_to root_path
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmation)
  end
end
