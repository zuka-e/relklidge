class PostsController < ApplicationController
  def index
    @posts = Post.page(params[:page])
  end

  def new
  end

  def show
  end
end
