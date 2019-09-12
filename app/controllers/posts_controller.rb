class PostsController < ApplicationController
  def index
    if params[:tag].present?
      @posts = Post.joins(:tags).where("tags.name = ?", params[:tag]).page(params[:page])
    else
      @posts = Post.page(params[:page])
    end
    @categories = Category.all
    @sections = Section.all
  end

  def new
  end

  def show
  end
end
