class CategoriesController < ApplicationController
  def index
    @categories = Category.page(params[:page])
  end
  def show
    @category = Category.find(params[:id])
    @sections = @category.sections
    # 例.タグに"民法"が含まれる投稿
    @posts = Post.joins(:tags).where("tags.name IN (?)",@category.name).page(params[:page])
  end
end
