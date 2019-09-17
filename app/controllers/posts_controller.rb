class PostsController < ApplicationController
  def index
    if params[:tag].present?
      @posts = Post.joins(:tags).where("tags.name = ? AND is_open = ?", params[:tag], true).page(params[:page])
    elsif params[:user].present?
      @posts = Post.joins(:user).where("users.name = ? AND is_open = ?", params[:user], true).page(params[:page])
    else
      @posts = Post.where(is_open: true).page(params[:page])
    end
    @categories = Category.all
    # group 重複まとめ, Arel.sql() 対injection, count() postの多い順(order用), pluck post_idのみ出力
    ranked_tag_ids = PostTag.group(:tag_id).order( Arel.sql("count(tag_id) DESC")).limit(10).pluck(:tag_id)
    @popular_tags = Tag.find(ranked_tag_ids)
  end

  def new
    @post = Post.new
    @post_tags_ids = PostTag.where("post_id = ?", @post.id).pluck(:tag_id)
    @tag = Tag.new
    @valid_tags = Tag.where.not("name = ?", "削除済タグ")
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
      @post.tags << Tag.find(params[:post][:tags])
      flash[:success] = '投稿が作成されました'
      redirect_to [@post.user, @post]
    else
      flash.now[:danger] = '保存されていません'
      @valid_tags = Tag.where.not("name = ?", "削除済タグ")
      render 'new'
    end
  end

  def show
    ranked_tag_ids = PostTag.group(:tag_id).order( Arel.sql("count(tag_id) DESC")).limit(10).pluck(:tag_id)
    @popular_tags = Tag.find(ranked_tag_ids)
    @post = Post.find_by(user_id: params[:user_id], id: params[:id], is_open: true)
    @comment = Comment.new
  end
  def update
    @post = Post.find_by(id: params[:id])
    if params[:post].present?
      if params[:new_tag] && params[:tag][:name].present?
        tag = Tag.create(tag_params)
        @post.tags << tag
      end
      params[:post][:is_open] == '1' ? @post.is_open = true : @post.is_open = false
      @post.update(post_params)
      @post.tags << Tag.find(params[:post][:tags]) if params[:post][:tags].present?
      flash[:success] = '変更が保存されました'
      respond_to do |format|
        format.html { redirect_back(fallback_location: params[:stored_url]) }
        format.js { render 'show'}
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: params[:stored_url]) }
        format.js
      end
    end
  end
  def destroy
    post = Post.find(params[:id])
    if post.destroy
      flash[:danger] = '投稿は削除されました'
      redirect_to posts_url
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :content, :writing_time)
    end
    def tag_params
			params.require(:tag).permit(:name)
		end

end
