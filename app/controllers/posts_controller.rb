class PostsController < ApplicationController
  def index
    @posts = Post.page(params[:page])
    @categories = Category.all
    @sections = Section.all
  end

  def new
  end

  def show
  end
end
