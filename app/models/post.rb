class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  default_scope -> { order(created_at: :DESC) }

  def liked_by?(user)
    self.likes.exists?(user_id: user.id)
  end

end
