class Admin::ItemsController < ApplicationController

  def show
    @category = Category.find(params[:category_id])
    @sections = @category.sections
    @item = Item.find(params[:id])
    @posts = Post.joins(:tags).where("tags.id IN (?)", @item.tags.ids).page(params[:page])
  end
  def edit
    @item = Item.find(params[:id])
    @tags = Tag.page(params[:page])
  end
  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:success] = '変更が保存されました'
      redirect_to [:admin, @item.section.category, @item.section, @item]
    else
      render 'edit'
    end
  end

  private

    def item_params
      params.require(:item).permit(:name, :content)
    end

end
