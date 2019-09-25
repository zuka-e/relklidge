class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags
  has_many :favorite_tags
  has_many :users, through: :favorite_tags
  has_many :item_tags
  has_many :items, through: :item_tags
  # default_scope -> { where.not(name: "削除済タグ") }
  # scope :unlimited , ->{ unscope(where: :name) } # Tag.unlimitedで解除

  validates :name,
    presence: { message: "タグ名を入力してください" },
    length: { minimum: 1, maximum: 10,  message: "タグ名は1文字以上、10文字以内で入力してください" },
    uniqueness: { case_sensitive: false, message: "このタグ名は既に使用されています" }

  def related_to?(user)
    self.favorite_tags.exists?(user_id: user.id)
  end
  def related_to_item?(item)
    self.item_tags.exists?(item_id: item.id)
  end
  def related_to_post?(post)
    self.post_tags.exists?(post_id: post.id)
  end

end
