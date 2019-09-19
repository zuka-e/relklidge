class Admin::ItemTagsController < ApplicationController

  def create
    @item = Item.find(params[:item_id])
    @tag = @item.item_tags.create(tag_id: params[:tag_id])
    @item_tag = Tag.find_by(id: params[:tag_id])
    respond_to do |format|
      format.html { redirect_back(fallback_location: admin_tags_path) }
      format.js
    end
  end

  def destroy
    @item = Item.find(params[:item_id])
    @tag = @item.item_tags.find_by(tag_id: params[:tag_id])
    @tag.destroy if @tag
    @item_tag = Tag.find_by(id: params[:tag_id])
    respond_to do |format|
      format.html { redirect_back(fallback_location: admin_tags_path) }
      format.js { render 'create' }
    end
  end
end
