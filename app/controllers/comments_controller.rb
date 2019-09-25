class CommentsController < ApplicationController

  before_action :log_in_request, only: [:create, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = params[:creator_id].to_i
    @comment.post_id = params[:post_id].to_i
    if @comment.save
      @post = Post.find_by(id: params[:post_id])
      @commenter = @comment.user
      @comment = Comment.new # 初期化
      respond_to do |format|
				format.html { redirect_back(fallback_location: params[:stored_url]) }
				format.js
			end
    else
      redirect_back(fallback_location: params[:stored_url])
    end
  end
  def update
    @comment = Comment.find(params[:id])
    @post = Post.find_by(id: params[:post_id])
    if params[:comment].present?
      @comment.update(comment_params)
      @commenter = @comment.user
      @comment = Comment.new # 初期化
      respond_to do |format|
        format.html { redirect_back(fallback_location: params[:stored_url]) }
        format.js { render 'create' }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: params[:stored_url]) }
        format.js
      end
    end
  end
  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      flash[:danger] = 'コメントは削除されました'
      redirect_back(fallback_location: params[:stored_url])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :content)
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
