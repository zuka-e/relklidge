class PostsController < ApplicationController
  def index
    if params[:tag].present?
      @posts = Post.joins(:tags).where("tags.name = ?", params[:tag]).page(params[:page])
    elsif params[:user].present?
      @posts = Post.joins(:user).where("users.name = ?", params[:user]).page(params[:page])
    else
      @posts = Post.page(params[:page])
    end
    @categories = Category.all
    # group 重複まとめ, Arel.sql() 対injection, count() postの多い順(order用), pluck post_idのみ出力
    ranked_tag_id = PostTag.group(:tag_id).order( Arel.sql("count(tag_id) DESC")).limit(10).pluck(:tag_id)
    @tags = Tag.find(ranked_tag_id)
  end

  def new
    @post = Post.new
    @post_tags_ids = PostTag.where("post_id = ?", @post.id).pluck(:tag_id)
    @tag = Tag.new
  end
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.is_open = true if params[:is_open]
    if params[:new_tag] && params[:tag][:name].present?
      tag = Tag.create(tag_params)
			@post.tags << tag
    end
    if @post.save
      @post.tags << Tag.find(params[:tags])
      flash[:success] = '投稿が作成されました'
      redirect_to @post
    else
      flash.now[:danger] = '保存されていません'
      render 'new'
    end
  end

  def show
    ranked_tag_id = PostTag.group(:tag_id).order( Arel.sql("count(tag_id) DESC")).limit(10).pluck(:tag_id)
    @tags = Tag.find(ranked_tag_id)
    @post = Post.find_by(user_id: params[:user_id], id: params[:id])
    @comment = Comment.new
  end

  private

    def post_params
      params.require(:post).permit(:title, :content, :writing_time)
    end
    def tag_params
			params.require(:tag).permit(:name)
		end

end
