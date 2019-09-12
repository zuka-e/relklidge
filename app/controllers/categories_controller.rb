class CategoriesController < ApplicationController
  def index
    @categories = Category.page(params[:page])
  end
  def show
    @category = Category.find(params[:id])
    # sections => (side-bar用)
    @sections = Section.where(category_id: @category.id)
    # 例.タグに民法が含まれる投稿
    @posts = Post.joins(:tags).where("tags.name IN (?)",@category.name).page(params[:page])
  end
end
