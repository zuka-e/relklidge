class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = params[:post_id].to_i
    if @comment.save
      @post = Post.find_by(id: params[:post_id])
      respond_to do |format|
				format.html { redirect_back(fallback_location: params[:stored_url]) }
				format.js
			end
    else
      redirect_back(fallback_location: params[:stored_url])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :content)
  end

end
