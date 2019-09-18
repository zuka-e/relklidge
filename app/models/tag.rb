class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags
  has_many :favorite_tags
  has_many :users, through: :favorite_tags
  has_many :item_tags
  has_many :items, through: :item_tags

  def related_to?(user)
    self.favorite_tags.exists?(user_id: user.id)
  end

end
