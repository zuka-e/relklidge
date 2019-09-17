class Admin::PostsController < ApplicationController
  def index
    if params[:tag].present?
      @posts = Post.joins(:tags).where("tags.name = ? AND is_open = ?", params[:tag], true).page(params[:page])
    elsif params[:user].present?
      @posts = Post.joins(:user).where("users.name = ? AND is_open = ?", params[:user], true).page(params[:page])
    elsif params[:commented_by].present?
      commented_posts_ids = Comment.joins(:user).group(:post_id).where("users.name = ?", params[:commented_by]).pluck(:post_id)
      @posts = Post.where("id = ? AND is_open = ?", commented_posts_ids, true).page(params[:page])
    else
      @posts = Post.where(is_open: true).page(params[:page])
    end

  end

  def new
    @post = Post.new
    @post_tags_ids = PostTag.where("post_id = ?", @post.id).pluck(:tag_id)
    @tag = Tag.new
    @valid_tags = Tag.where.not("name = ?", "削除済タグ")
  end
  def create
    @post = Post.new(post_params)
    @post.user = User.first
    @post.is_open = false unless params[:is_open]
    if params[:new_tag] && params[:tag][:name].present?
      @tag = Tag.create(tag_params)
			@post.tags << @tag
    end
    if @post.save
      @post.tags << Tag.find(params[:post][:tags])
      flash[:success] = '投稿が作成されました'
      redirect_to [:admin, @post.user, @post]
    else
      flash.now[:danger] = '保存されていません'
      @valid_tags = Tag.where.not("name = ?", "削除済タグ")
      render 'new'
    end
  end
  def show
    ranked_tag_ids = PostTag.group(:tag_id).order( Arel.sql("count(tag_id) DESC")).limit(10).pluck(:tag_id)
    @popular_tags = Tag.find(ranked_tag_ids)
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
