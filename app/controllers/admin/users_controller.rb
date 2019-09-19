class Admin::UsersController < ApplicationController

  def index
    if params[:name].present?
      @users = @users.where(["name LIKE ?", "%#{params[:name]}%"])
    else
      @users = User.page(params[:page])
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

  def quit
    @user = User.find(params[:id])
    @user.is_quit = true
    if @user.save
      flash[:warning] = "退会処理が正常に完了しました"
      redirect_to admin_users_path
    end
  end

end
