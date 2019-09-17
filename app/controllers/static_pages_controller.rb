class StaticPagesController < ApplicationController
  def home
    @categories = Category.all
    # group 重複まとめ, Arel.sql() 対injection, count() postの多い順(order用), pluck post_idのみ出力
    ranked_tag_ids = PostTag.group(:tag_id).order( Arel.sql("count(tag_id) DESC")).limit(10).pluck(:tag_id)
    @popular_tags = Tag.find(ranked_tag_ids)
    @posts = Post.where("is_open = ?", true).page(params[:page])
    ranked_post_ids = Like.group(:post_id).order( Arel.sql("count(post_id) DESC")).limit(10).pluck(:post_id)
    @popular_posts = Post.find(ranked_post_ids)
  end

  def about
  end

  def help
  end
end
