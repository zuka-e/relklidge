class FavoriteTagsController < ApplicationController

  def create
    @tag = current_user.favorite_tags.create(tag_id: params[:tag_id])
    @favorite_tag = Tag.find_by(id: params[:tag_id])
    respond_to do |format|
      format.html { redirect_back(fallback_location: tags_path) }
      format.js
    end
  end

  def destroy
    @tag = current_user.favorite_tags.find_by(tag_id: params[:tag_id])
    @tag.destroy if @tag
    @favorite_tag = Tag.find_by(id: params[:tag_id])
    respond_to do |format|
      format.html { redirect_back(fallback_location: tags_path) }
      format.js
    end
  end

end
