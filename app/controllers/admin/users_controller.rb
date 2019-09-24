class Admin::UsersController < ApplicationController

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
    if params[:name].present?
      @users = @users.where(["name LIKE ?", "%#{params[:name]}%"])
    end
  end

  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.page(params[:page])
    @liked_posts = @user.liked_posts.page(params[:page])
    @commented_posts = @user.commented_posts.group(:post_id).page(params[:page])
    # ランダムに選んだお気に入りタグの投稿をおすすめとする
    number = (0...@user.tags.count).to_a.sample
    @recommended_posts =  @user.tags[number].posts.page(params[:page]) unless number.blank?
    @favorite_tags = @user.tags.uniq
  end

  def quit
    @user = User.find(params[:id])
    @user.is_quit = true
    if @user.save
      @user.update_attribute(:name, "#{@user.name}@")
      @user.update_attribute(:email, "#{@user.email}@")
      flash[:warning] = "退会処理が正常に完了しました"
      redirect_to admin_users_path
    end
  end

end
