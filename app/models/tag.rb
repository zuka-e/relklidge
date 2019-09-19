class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags
  has_many :favorite_tags
  has_many :users, through: :favorite_tags
  has_many :item_tags
  has_many :items, through: :item_tags
  default_scope -> { where.not(name: "削除済タグ") }
  scope :unlimited , ->{ unscope(where: :name) } # Tag.unlimitedで解除

  def related_to?(user)
    self.favorite_tags.exists?(user_id: user.id)
  end
  def related_to_item?(item)
    self.item_tags.exists?(item_id: item.id)
  end

end
