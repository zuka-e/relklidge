class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags
  has_many :favorite_tags
  has_many :users, through: :favorite_tags
end
