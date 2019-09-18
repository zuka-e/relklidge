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
    @posts_with_tag = Post.joins(:tags).where("tags.name = ? AND is_open = ?", params[:tag], true).page(params[:page])
    liked_posts_ids = Like.joins(:user).group(:post_id).where("users.id = ?", params[:id]).pluck(:post_id)
    @liked_posts = Post.where("id IN (?) AND is_open = ?", liked_posts_ids, true).page(params[:page])
    commented_posts_ids = Comment.joins(:user).group(:post_id).where("users.id = ?", params[:id]).pluck(:post_id)
    @commented_posts = Post.where("id IN (?) AND is_open = ?", commented_posts_ids, true).page(params[:page])
    @user_posts = Post.where("user_id = ? AND is_open = ?", params[:id], true).page(params[:page])
    favorite_tags_ids = FavoriteTag.where("user_id = ?", params[:id]).pluck(:tag_id)
    @favorite_tags = Tag.find(favorite_tags_ids)
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
