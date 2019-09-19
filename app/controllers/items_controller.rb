class ItemsController < ApplicationController

  def show
    @category = Category.find(params[:category_id])
    @sections = @category.sections
    @item = Item.find(params[:id])
    @posts = Post.joins(:tags).where("tags.id IN (?)", @item.tags.ids).page(params[:page])
  end

end
