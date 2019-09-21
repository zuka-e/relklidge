class PostTagsController < ApplicationController

  def create
    @post = Post.unlimited.find(params[:post_id])
    @post_tag = @post.post_tags.create(tag_id: params[:tag_id])
    @tag = Tag.find_by(id: params[:tag_id])
    respond_to do |format|
      format.html { redirect_back(fallback_location: posts_url) }
      format.js
    end
  end

  def destroy
    @post = Post.unlimited.find(params[:post_id])
    @post_tag = @post.post_tags.find_by(tag_id: params[:tag_id])
    @post_tag.destroy if @post_tag
    @tag = Tag.find_by(id: params[:tag_id])
    respond_to do |format|
      format.html { redirect_back(fallback_location: posts_url) }
      format.js { render 'create' }
    end
  end

end
