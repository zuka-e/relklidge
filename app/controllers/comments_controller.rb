class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = params[:creator_id].to_i
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
  def update
    @comment = Comment.find(params[:id])
    @post = Post.find_by(id: params[:post_id])
    if params[:comment].present?
      @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_back(fallback_location: params[:stored_url]) }
        format.js { render 'create' }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: params[:stored_url]) }
        format.js
      end
    end
  end
  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      flash[:danger] = 'コメントは削除されました'
      redirect_back(fallback_location: params[:stored_url])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :content)
  end

end
