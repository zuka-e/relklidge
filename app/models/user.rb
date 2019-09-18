class User < ApplicationRecord
  has_secure_password
  attachment :image
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :commented_posts, through: :comments, source: :post, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post, dependent: :destroy
  has_many :favorite_tags, dependent: :destroy
  has_many :tags, through: :favorite_tags

  enum is_quit:{利用中: false, 退会済: true}

end
