class UsersController < ApplicationController

  before_action :log_in_request, only: [:show, :edit, :update, :withdrawal, :quit]
  before_action :authenticate_user, only: [:show, :edit, :update, :withdrawal, :quit]

  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    @user.activation_token = SecureRandom.urlsafe_base64 # ランダムな文字列生成
    @user.update_attribute(:activation_digest, User.digest(@user.activation_token))
    if @user.save
      ActivationMailer.activation(@user).deliver_now
      flash[:info] = '仮登録が完了しました、メールをご確認ください'
      redirect_to root_url
    else
      render 'new'
    end
  end
  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.unlimited.page(params[:page]).per(10)
    @liked_posts = @user.liked_posts.page(params[:page]).per(10)
    @commented_posts = @user.commented_posts.group(:id).page(params[:page]).per(10)
    # ランダムに選んだお気に入りタグの投稿をおすすめとする
    number = (0...@user.tags.count).to_a.sample
    @recommended_posts =  @user.tags[number].posts.page(params[:page]).per(10) unless number.blank?
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
        flash[:danger] = "パスワードが一致しません"
        render 'edit'
      end
    else
      if @user.update(user_params)
        flash[:success] = "登録情報を更新しました"
        redirect_to @user
      else
        render 'edit'
      end
    end
  end

  def withdrawal
    @user = User.find_by(id: params[:id])
  end
  def quit
    @user = User.find(params[:id])
    @user.is_quit = true
    if @user.save
      @user.update_attribute(:name, "#{@user.name}@")
      @user.update_attribute(:email, "#{@user.email}@")
      flash[:warning] = "退会処理が正常に完了しました"
      session.delete(:user_id)
      @current_user = nil
      redirect_to root_url
    else
      flash[:danger] = "退会処理にエラーが発生しました"
      render 'withdrawal'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :image, :password,:password_confirmation)
    end

    def log_in_request
      unless log_in?
        session[:forwarding_url] = request.original_url # ログイン時に使用
        flash[:danger] = "ログインが必要です"
        redirect_to login_url
      end
    end
    def authenticate_user
      @user = User.find_by(id: params[:id])
      unless @user == current_user
        flash[:danger] = "不正なアクセスです"
        redirect_to root_url
      end
    end

end
