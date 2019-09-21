class Admin::TagsController < ApplicationController
  def index
    @q = Tag.ransack(params[:q])
    @tags = @q.result(distinct: true).page(params[:page])
  end
  def destroy
    tag = Tag.find(params[:id])
    # if tag.update(name: '削除済タグ')
    #   flash[:danger] = "'削除済タグ'に変更しました"
    if tag.destroy
      flash[:danger] = "タグを削除しました"
      redirect_to admin_tags_url
    end
  end
end
