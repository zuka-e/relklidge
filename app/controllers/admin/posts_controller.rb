class Admin::PostsController < ApplicationController
  def index
    if params[:tag].present? # URLに表示させるため名前で検索
      @posts = Post.joins(:tags).where("tags.name = ? AND is_open = ?", params[:tag], true).page(params[:page])
    elsif params[:user].present?
      @posts = Post.joins(:user).where("users.name = ? AND is_open = ?", params[:user], true).page(params[:page])
    elsif params[:commented_by].present?
      commented_posts_ids = Comment.joins(:user).group(:post_id).where("users.name = ?", params[:commented_by]).pluck(:post_id)
      @posts = Post.where("id = ? AND is_open = ?", commented_posts_ids, true).page(params[:page])
    else
      @posts = Post.where(is_open: true).page(params[:page])
    end

  end

  def show
  end

  def new
  end
end
