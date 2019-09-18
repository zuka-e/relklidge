class LikesController < ApplicationController

  def create
    @liked_post = Post.find_by(id: params[:post_id])
    @like = current_user.likes.create(post_id: @liked_post.id)
    respond_to do |format|
      format.html { redirect_back(fallback_location: request.url) }
      format.js
    end
  end

  def destroy
    @liked_post = Post.find_by(id: params[:post_id])
    @like = current_user.likes.find_by(post_id: @liked_post.id)
    @like.destroy if @like
    respond_to do |format|
      format.html { redirect_back(fallback_location: request.url) }
      format.js
    end
  end

end
