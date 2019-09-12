class PostsController < ApplicationController
  def index
    if params[:tag].present?
      @posts = Post.joins(:tags).where("tags.name = ?", params[:tag]).page(params[:page])
    else
      @posts = Post.page(params[:page])
    end
    @categories = Category.all
    # group 重複まとめ, Arel.sql() 対injection, count() postの多い順(order用), pluck post_idのみ出力
    ranked_tag_id = PostTag.group(:tag_id).order( Arel.sql("count(tag_id) DESC")).limit(10).pluck(:tag_id)
    @tags = Tag.find(ranked_tag_id)
  end

  def new
  end

  def show
  end
end
