class PostsController < ApplicationController

  before_action :log_in_request, only: [:new, :create, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:create, :edit, :update, :destroy]

  def index
    if params[:tag].present?
      @posts = Post.joins(:tags).where("tags.name = ?", params[:tag]).page(params[:page])
    elsif params[:user].present?
      @posts = Post.joins(:user).where("users.name = ?", params[:user]).page(params[:page])
    else
      @posts = Post.page(params[:page])
    end
    @categories = Category.all
    # group 重複まとめ, Arel.sql() 対injection, count() postの多い順(order用), pluck post_idのみ出力
    ranked_tag_ids = PostTag.group(:tag_id).order( Arel.sql("count(tag_id) DESC")).limit(10).pluck(:tag_id)
    @popular_tags = Tag.where(id: ranked_tag_ids)
  end

  def new
    @post = Post.new
    @tag = Tag.new
    @tags = Tag.page(params[:page])
  end
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    params[:post][:is_open] == '1' ? @post.is_open = true : @post.is_open = false
    if @post.save
      @post.post_tags.create(tag: Tag.create(tag_params))
      flash[:success] = '投稿が作成されました'
      redirect_to [@post.user, @post]
    else
      @tags = Tag.page(params[:page])
      render 'new'
    end
  end

  def show
    if log_in? && params[:user_id].to_i == current_user.id
      @post = Post.unlimited.find_by(id: params[:id], user: current_user)
    else
      @post = Post.find_by(id: params[:id], user_id: params[:user_id])
    end
    redirect_back(fallback_location: root_url) if @post.nil?
    @comment = Comment.new
    ranked_tag_ids = PostTag.group(:tag_id).order( Arel.sql("count(tag_id) DESC")).limit(10).pluck(:tag_id)
    @popular_tags = Tag.where(id: ranked_tag_ids)
  end
  def edit
    @post = Post.unlimited.find_by(id: params[:id], user: current_user)
    @tags = Tag.page(params[:page])
    respond_to do |format|
      format.html { redirect_back(fallback_location: params[:stored_url]) }
      format.js
    end
  end
  def update
    @post = Post.unlimited.find_by(params[:id], user: current_user)
    params[:post][:is_open] == '1' ? @post.is_open = true : @post.is_open = false
    if @post.update(post_params)
      @post.post_tags.create(tag: Tag.create(tag_params))
      flash[:success] = '変更が保存されました'
      respond_to do |format|
        format.html { redirect_back(fallback_location: params[:stored_url]) }
        format.js { render 'show'}
      end
    else
      flash.now[:danger] = '保存されていません'
      redirect_back(fallback_location: params[:stored_url])
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      flash[:danger] = '投稿は削除されました'
      redirect_to posts_url
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :content, :writing_time)
    end
    def tag_params
			params.require(:tag).permit(:name)
		end

    def log_in_request
      unless log_in?
        session[:forwarding_url] = request.original_url # ログイン時に使用
        flash[:danger] = "ログインが必要です"
        redirect_to login_url
      end
    end
    def authenticate_user
      @user = User.find_by(id: params[:user_id])
      unless @user == current_user
        flash[:danger] = "不正なアクセスです"
        redirect_to root_url
      end
    end
end
