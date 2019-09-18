class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "登録が完了しました"
      redirect_to @user
    else
      render 'new'
    end
  end
  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.page(params[:page])
    @liked_posts = @user.liked_posts.page(params[:page])
    @commented_posts = @user.commented_posts.group(:post_id).page(params[:page])
    # ランダムに選んだお気に入りタグの投稿をおすすめとする
    number = (0...@user.tags.count).to_a.sample
    @recommended_posts =  @user.tags[number].posts.page(params[:page])
    @favorite_tags = @user.tags.uniq
  end

  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if params[:user][:password].present?
      if @user.authenticate(params[:user][:current_password])
        @user.update(user_params)
        flash[:success] = "登録情報を更新しました"
        redirect_to @user
      else
        flash.now[:danger] = "登録情報が更新されませんでした"
        render 'edit'
      end
    else
      if @user.update(user_params)
        flash[:success] = "登録情報を更新しました"
        redirect_to @user
      else
        flash.now[:danger] = "登録情報が更新されませんでした"
        render 'edit'
      end
    end
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
